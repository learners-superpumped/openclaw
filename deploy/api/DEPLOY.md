# openclaw-api 배포 가이드

## 사전 준비

- GKE 클러스터 접근 (`kubectl` 설정 완료)
- Artifact Registry 접근 (`gcloud auth configure-docker us-central1-docker.pkg.dev`)
- Cloud SQL PostgreSQL 인스턴스 (Public IP)
- `openclaw` 네임스페이스 생성 완료

---

## 1. Cloud SQL 데이터베이스 생성

Cloud SQL PostgreSQL 인스턴스에 `openclaw` 데이터베이스를 생성한다.

```bash
# Cloud SQL 인스턴스에 접속
gcloud sql connect <INSTANCE_NAME> --user=postgres

# DB 및 유저 생성
CREATE DATABASE openclaw;
CREATE USER openclaw_api WITH PASSWORD '<비밀번호>';
GRANT ALL PRIVILEGES ON DATABASE openclaw TO openclaw_api;

# 접속 종료 후 Public IP 확인
gcloud sql instances describe <INSTANCE_NAME> --format='value(ipAddresses[0].ipAddress)'
```

> Cloud SQL에서 GKE 노드 IP 대역에 대한 **Authorized Networks** 설정이 필요하다.

---

## 2. DNS 및 SSL (자동)

클러스터에 설치된 **external-dns**가 Ingress 리소스를 감지하여 Cloud DNS에 A 레코드를 자동 생성한다.
**ManagedCertificate**가 SSL 인증서를 자동 발급한다.

- 도메인: `api.openclaw.zazz.buzz`
- DNS Zone: `zazz-buzz` (Cloud DNS)
- SSL: GKE ManagedCertificate (자동 발급, 최대 15분)

> 별도의 수동 DNS 등록이나 SSL 설정이 필요 없다. Ingress를 배포하면 자동으로 처리된다.

---

## 3. K8s Secret 생성

```bash
kubectl create secret generic openclaw-api -n openclaw \
  --from-literal=DATABASE_URL="postgresql://openclaw_api:<비밀번호>@<CLOUD_SQL_PUBLIC_IP>:5432/openclaw" \
  --from-literal=JWT_SECRET="$(openssl rand -base64 32)" \
  --from-literal=MANAGER_API_KEY="<기존 Manager API Key>" \
  --from-literal=GOOGLE_CLIENT_ID="<Google OAuth Web Client ID>" \
  --from-literal=APPLE_CLIENT_ID="<Apple Service ID>" \
  --from-literal=OPENROUTER_MANAGEMENT_KEY="<OpenRouter 관리 키>"
```

기존 Manager API Key 확인:

```bash
kubectl get secret openclaw-manager -n openclaw -o jsonpath='{.data.API_KEY}' | base64 -d
```

### OAuth 인증 정보

- **Google**: [Google Cloud Console](https://console.cloud.google.com/apis/credentials) → OAuth 2.0 Client → **Web Client ID** 사용 (Android Client ID가 아님)
- **Apple**: [Apple Developer Console](https://developer.apple.com/account/resources/identifiers) → Service ID 생성
- **OpenRouter**: [OpenRouter Keys](https://openrouter.ai/settings/keys) 페이지에서 관리 키 발급

---

## 4. Docker 이미지 빌드 및 푸시

```bash
cd deploy/api

# 이미지 빌드
docker build --platform linux/amd64 -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest .

# Artifact Registry에 푸시
docker push us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest
```

---

## 5. Prisma 마이그레이션

로컬에서 Cloud SQL에 직접 마이그레이션을 실행한다.

```bash
cd deploy/api

# DATABASE_URL을 환경변수로 설정
export DATABASE_URL="postgresql://openclaw_api:<비밀번호>@<CLOUD_SQL_PUBLIC_IP>:5432/openclaw"

# 마이그레이션 생성 및 적용 (최초 1회)
npx prisma migrate dev --name init

# 이후 배포 시에는 deploy 명령 사용
npx prisma migrate deploy
```

> Cloud SQL의 Public IP에 로컬 IP가 Authorized Networks에 등록되어 있어야 한다.

---

## 6. K8s 매니페스트 배포

```bash
# Deployment + Service
kubectl apply -f deploy/api/k8s/api-deployment.yaml

# Ingress + ManagedCertificate (SSL 자동 발급 + DNS 자동 등록)
kubectl apply -f deploy/api/k8s/api-ingress.yaml
```

---

## 7. 배포 확인

```bash
# Pod 상태 확인
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-api

# 로그 확인
kubectl logs -n openclaw -l app.kubernetes.io/name=openclaw-api -f

# Ingress 상태 확인 (IP 할당 → external-dns가 DNS 자동 등록)
kubectl get ingress openclaw-api -n openclaw

# ManagedCertificate 상태 확인 (Provisioning → Active, 최대 15분)
kubectl get managedcertificate openclaw-api-cert -n openclaw

# DNS 자동 등록 확인
gcloud dns record-sets list --zone=zazz-buzz --filter="name=api.openclaw.zazz.buzz."

# HTTPS 접속 테스트 (SSL Active 이후)
curl https://api.openclaw.zazz.buzz/health
```

---

## 8. API 동작 테스트

```bash
# Health check (내부)
kubectl exec -n openclaw deploy/openclaw-api -- curl -s http://localhost:4000/health

# 회원가입 (이메일/비밀번호)
curl -X POST https://api.openclaw.zazz.buzz/auth/signup \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","password":"Test1234!"}'

# 이메일 로그인
curl -X POST https://api.openclaw.zazz.buzz/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","password":"Test1234!"}'

# Google 소셜 로그인 (Flutter 앱에서 받은 ID Token 사용)
curl -X POST https://api.openclaw.zazz.buzz/auth/google \
  -H 'Content-Type: application/json' \
  -d '{"idToken":"<Google ID Token>"}'

# Apple 소셜 로그인 (iOS/macOS 앱에서 받은 Identity Token 사용)
curl -X POST https://api.openclaw.zazz.buzz/auth/apple \
  -H 'Content-Type: application/json' \
  -d '{"identityToken":"<Apple Identity Token>","givenName":"길동","familyName":"홍"}'

# JWT 토큰 갱신
curl -X POST https://api.openclaw.zazz.buzz/auth/refresh \
  -H 'Content-Type: application/json' \
  -d '{"refreshToken":"<refresh_token>"}'

# 내 프로필 조회
curl https://api.openclaw.zazz.buzz/users/me \
  -H 'Authorization: Bearer <access_token>'

# 인스턴스 생성 (JWT 필요, OpenRouter API Key 자동 생성)
curl -X POST https://api.openclaw.zazz.buzz/instances \
  -H 'Authorization: Bearer <access_token>' \
  -H 'Content-Type: application/json' \
  -d '{"displayName":"내 인스턴스"}'

# 내 인스턴스 목록
curl https://api.openclaw.zazz.buzz/instances \
  -H 'Authorization: Bearer <access_token>'

# 인스턴스 상세 조회 (Manager 프록시 → phase 포함)
curl https://api.openclaw.zazz.buzz/instances/<instance_id> \
  -H 'Authorization: Bearer <access_token>'
```

---

## 9. Telegram 채널 연동 E2E 테스트

인스턴스가 생성되고 Running 상태인 것을 확인한 뒤, 아래 순서로 Telegram 봇 연동 및 DM 페어링을 테스트한다.

### 사전 준비

- BotFather에서 Telegram 봇을 생성하고 **봇 토큰**을 발급받는다 (`123456:ABC-DEF...` 형식)
- JWT access_token을 확보한다 (로그인 API 호출)
- 테스트 대상 인스턴스 ID를 확인한다 (`GET /instances`)

### 9-1. Telegram 봇 토큰 설정

```bash
# 봇 토큰 등록
curl -X POST https://api.openclaw.zazz.buzz/instances/<INSTANCE_ID>/telegram/setup \
  -H 'Authorization: Bearer <access_token>' \
  -H 'Content-Type: application/json' \
  -d '{"botToken":"123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"}'

# 기대 응답
# { "ok": true, "config": { ... } }
```

### 9-2. Telegram 연결 상태 확인

```bash
# probe=true 로 실시간 상태 확인
curl https://api.openclaw.zazz.buzz/instances/<INSTANCE_ID>/telegram/status?probe=true \
  -H 'Authorization: Bearer <access_token>'

# 기대 응답
# { "userId": "...", "telegram": { "running": true, ... }, "accounts": ... }
```

> setup 직후에는 게이트웨이가 재시작되므로, 몇 초 대기 후 status를 호출한다.

### 9-3. DM 페어링 요청 조회

Telegram 봇에 DM을 보낸 사용자의 페어링 요청 목록을 조회한다.

```bash
curl https://api.openclaw.zazz.buzz/instances/<INSTANCE_ID>/pairing/list?channel=telegram \
  -H 'Authorization: Bearer <access_token>'

# 기대 응답
# { "channel": "telegram", "requests": [{ "id": "123456", "code": "ABC3KLM9", ... }] }
```

### 9-4. DM 페어링 승인

조회된 페어링 코드를 사용하여 승인한다.

```bash
curl -X POST https://api.openclaw.zazz.buzz/instances/<INSTANCE_ID>/pairing/approve \
  -H 'Authorization: Bearer <access_token>' \
  -H 'Content-Type: application/json' \
  -d '{"channel":"telegram","code":"ABC3KLM9","notify":true}'

# 기대 응답
# { "approved": true, ... }
```

> `notify: true`로 설정하면 승인된 사용자에게 알림 메시지가 전송된다.

### 9-5. Telegram 연결 해제

```bash
curl -X POST https://api.openclaw.zazz.buzz/instances/<INSTANCE_ID>/telegram/logout \
  -H 'Authorization: Bearer <access_token>' \
  -H 'Content-Type: application/json' \
  -d '{}'

# 기대 응답
# { "channel": "telegram", "cleared": true, "loggedOut": true }
```

### 트러블슈팅 — Telegram

| 증상                               | 확인 사항                                                               |
| ---------------------------------- | ----------------------------------------------------------------------- |
| setup 후 status가 `running: false` | Pod 로그 확인 (`kubectl logs`), 봇 토큰이 유효한지 BotFather에서 재확인 |
| pairing list가 빈 배열             | Telegram 앱에서 봇에 `/start` 또는 아무 메시지를 보낸 후 재시도         |
| pairing approve 실패               | code가 정확한지 확인, 대소문자 구분됨                                   |
| status 502 에러                    | 인스턴스가 Running 상태인지 확인 (`GET /instances/<ID>`)                |

---

## 업데이트 배포

코드 변경 후 재배포:

```bash
cd deploy/api

# 1. 이미지 빌드 & 푸시
docker build --platform linux/amd64 -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest .
docker push us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest

# 2. DB 마이그레이션 (스키마 변경이 있을 때만)
export DATABASE_URL="postgresql://..."
npx prisma migrate deploy

# 3. Pod 재시작
kubectl rollout restart deployment/openclaw-api -n openclaw

# 4. 롤아웃 확인
kubectl rollout status deployment/openclaw-api -n openclaw
```

---

## 환경 변수

| 변수                        | 설명                         | 소스                  |
| --------------------------- | ---------------------------- | --------------------- |
| `PORT`                      | 서버 포트                    | Deployment env (4000) |
| `DATABASE_URL`              | PostgreSQL 연결 문자열       | Secret `openclaw-api` |
| `JWT_SECRET`                | JWT 서명 키                  | Secret `openclaw-api` |
| `MANAGER_URL`               | Manager 내부 URL             | Deployment env        |
| `MANAGER_API_KEY`           | Manager 인증 키              | Secret `openclaw-api` |
| `GOOGLE_CLIENT_ID`          | Google OAuth Web Client ID   | Secret `openclaw-api` |
| `APPLE_CLIENT_ID`           | Apple Sign-In Service ID     | Secret `openclaw-api` |
| `OPENROUTER_MANAGEMENT_KEY` | OpenRouter 키 생성용 관리 키 | Secret `openclaw-api` |

---

## 트러블슈팅

### Pod CrashLoopBackOff

```bash
kubectl logs -n openclaw -l app.kubernetes.io/name=openclaw-api --previous
```

주요 원인: DATABASE_URL 오류, JWT_SECRET 미설정, Cloud SQL 접근 불가

### Google 소셜 로그인 실패

- `GOOGLE_CLIENT_ID` 환경변수가 **Web Client ID**인지 확인 (Android Client ID가 아님)
- Google Cloud Console에서 OAuth 동의 화면 설정 확인
- Android 앱의 SHA-1 지문이 Google Cloud Console의 Android Client에 등록되어 있는지 확인
- Flutter 앱에서 `serverClientId`에 Web Client ID를 전달하는지 확인 (Android에서 `idToken`을 받기 위해 필수)

### Apple 소셜 로그인 실패

- `APPLE_CLIENT_ID`가 Apple Developer Console의 Service ID와 일치하는지 확인
- Xcode의 Signing & Capabilities에서 "Sign In with Apple" capability 추가 확인
- Associated Domains 설정 확인

### JWT 토큰 관련

- `JWT_SECRET`이 모든 API Pod에서 동일한 값인지 확인 (Secret에서 주입)
- access token 만료: 15분, refresh token 만료: 7일
- 401 응답 시 `/auth/refresh`로 갱신 필요

### Prisma 마이그레이션 실패

```bash
# 마이그레이션 상태 확인
export DATABASE_URL="postgresql://..."
npx prisma migrate status

# 실패한 마이그레이션 롤백
npx prisma migrate resolve --rolled-back <migration_name>
```

### Ingress 502 Bad Gateway

- Pod readiness probe 실패 → Pod 로그 확인
- Service selector 불일치 → `kubectl describe svc openclaw-api -n openclaw`

### ManagedCertificate Provisioning 상태 지속

- external-dns가 DNS A 레코드를 생성했는지 확인: `gcloud dns record-sets list --zone=zazz-buzz --filter="name=api.openclaw.zazz.buzz."`
- 최대 15분 대기, 그래도 안 되면 `kubectl describe managedcertificate openclaw-api-cert -n openclaw`
- external-dns Pod 로그 확인: `kubectl logs -l app=external-dns --all-namespaces`

---

## API 엔드포인트

### 인증 불필요 (Public)

| 메서드 | 경로            | 설명               | 요청 Body                                    |
| ------ | --------------- | ------------------ | -------------------------------------------- |
| POST   | `/auth/signup`  | 이메일 회원가입    | `{ email, password, name? }`                 |
| POST   | `/auth/login`   | 이메일 로그인      | `{ email, password }`                        |
| POST   | `/auth/google`  | Google 소셜 로그인 | `{ idToken }`                                |
| POST   | `/auth/apple`   | Apple 소셜 로그인  | `{ identityToken, givenName?, familyName? }` |
| POST   | `/auth/refresh` | JWT 토큰 갱신      | `{ refreshToken }`                           |
| GET    | `/health`       | 헬스체크           | —                                            |

### JWT 인증 필요 (`Authorization: Bearer <JWT>`)

| 메서드 | 경로                                           | 설명                  |
| ------ | ---------------------------------------------- | --------------------- |
| GET    | `/users/me`                                    | 내 프로필 조회        |
| POST   | `/instances`                                   | 인스턴스 생성         |
| GET    | `/instances`                                   | 내 인스턴스 목록      |
| GET    | `/instances/:id`                               | 인스턴스 상세 조회    |
| DELETE | `/instances/:id`                               | 인스턴스 삭제         |
| POST   | `/instances/:id/telegram/setup`                | Telegram 봇 토큰 설정 |
| GET    | `/instances/:id/telegram/status[?probe=true]`  | Telegram 연결 상태    |
| POST   | `/instances/:id/telegram/logout`               | Telegram 연결 해제    |
| GET    | `/instances/:id/pairing/list?channel=telegram` | 페어링 요청 조회      |
| POST   | `/instances/:id/pairing/approve`               | 페어링 승인           |
| POST   | `/instances/:id/whatsapp/qr`                   | WhatsApp QR 요청      |
| POST   | `/instances/:id/whatsapp/wait`                 | WhatsApp 연결 대기    |
| GET    | `/instances/:id/whatsapp/status`               | WhatsApp 연결 상태    |
| POST   | `/instances/:id/rpc`                           | RPC 호출 (프록시)     |

---

## Flutter 앱 (ClawBox) 연동

### 앱 온보딩 플로우

```
1. RevenueCat 페이월 → 구독 완료
2. POST /auth/google (or /auth/apple)  → accessToken, refreshToken
3. POST /instances                      → 인스턴스 자동 생성
4. GET  /instances/:id                  → 폴링 (phase: pending → running)
5. POST /instances/:id/telegram/setup   → 봇 토큰 설정
6. GET  /instances/:id/telegram/status  → 연결 확인
7. (Telegram 앱에서 봇에 DM 전송)
8. GET  /instances/:id/pairing/list     → 페어링 코드 조회
9. POST /instances/:id/pairing/approve  → 페어링 승인
10. 대시보드 → 인스턴스/Telegram 상태 표시
```

### 앱 설정 (constants.dart)

```dart
const String revenueCatApiKey = '<RevenueCat API Key>';
const String entitlementId = 'ClawBox Pro';
const String apiBaseUrl = 'https://api.openclaw.app';
const String googleServerClientId = '<Google OAuth Web Client ID>';
```

> `googleServerClientId`는 `GOOGLE_CLIENT_ID`와 동일한 **Web Client ID**를 사용해야 한다.
