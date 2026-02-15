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

## 2. DNS 레코드 등록

`api.openclaw.zazz.buzz`에 대한 A 레코드를 GKE Ingress의 외부 IP로 설정한다.

```bash
# Ingress 배포 후 외부 IP 확인 (5단계 이후)
kubectl get ingress openclaw-api -n openclaw -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

> GCE Ingress는 IP 할당에 수 분이 걸린다. IP가 할당되면 DNS에 A 레코드를 추가한다.

---

## 3. K8s Secret 생성

```bash
kubectl create secret generic openclaw-api -n openclaw \
  --from-literal=DATABASE_URL="postgresql://openclaw_api:<비밀번호>@<CLOUD_SQL_PUBLIC_IP>:5432/openclaw" \
  --from-literal=JWT_SECRET="$(openssl rand -base64 32)" \
  --from-literal=MANAGER_API_KEY="<기존 Manager API Key>"
```

기존 Manager API Key 확인:

```bash
kubectl get secret openclaw-manager -n openclaw -o jsonpath='{.data.API_KEY}' | base64 -d
```

---

## 4. Docker 이미지 빌드 및 푸시

```bash
cd deploy/api

# 이미지 빌드
docker build -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest .

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
cd deploy/api

# Deployment + Service
kubectl apply -f k8s/api-deployment.yaml

# Ingress + ManagedCertificate
kubectl apply -f k8s/api-ingress.yaml
```

---

## 7. 배포 확인

```bash
# Pod 상태 확인
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-api

# 로그 확인
kubectl logs -n openclaw -l app.kubernetes.io/name=openclaw-api -f

# Readiness 확인
kubectl get deployment openclaw-api -n openclaw

# Ingress 상태 확인 (IP 할당까지 수 분 소요)
kubectl get ingress openclaw-api -n openclaw

# ManagedCertificate 상태 확인 (Active까지 최대 15분)
kubectl get managedcertificate openclaw-api-cert -n openclaw
```

---

## 8. API 동작 테스트

```bash
# Health check (내부)
kubectl exec -n openclaw deploy/openclaw-api -- curl -s http://localhost:4000/health

# 회원가입 (외부, 인증서 발급 완료 후)
curl -X POST https://api.openclaw.zazz.buzz/auth/signup \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","password":"Test1234!"}'

# 로그인
curl -X POST https://api.openclaw.zazz.buzz/auth/login \
  -H 'Content-Type: application/json' \
  -d '{"email":"test@example.com","password":"Test1234!"}'

# 인스턴스 생성 (JWT 필요)
curl -X POST https://api.openclaw.zazz.buzz/instances \
  -H 'Authorization: Bearer <access_token>' \
  -H 'Content-Type: application/json' \
  -d '{"secrets":{"ANTHROPIC_API_KEY":"sk-..."}}'

# 내 인스턴스 목록
curl https://api.openclaw.zazz.buzz/instances \
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
docker build -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest .
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

| 변수              | 설명                   | 소스                  |
| ----------------- | ---------------------- | --------------------- |
| `PORT`            | 서버 포트              | Deployment env (4000) |
| `DATABASE_URL`    | PostgreSQL 연결 문자열 | Secret `openclaw-api` |
| `JWT_SECRET`      | JWT 서명 키            | Secret `openclaw-api` |
| `MANAGER_URL`     | Manager 내부 URL       | Deployment env        |
| `MANAGER_API_KEY` | Manager 인증 키        | Secret `openclaw-api` |

---

## 트러블슈팅

### Pod CrashLoopBackOff

```bash
kubectl logs -n openclaw -l app.kubernetes.io/name=openclaw-api --previous
```

주요 원인: DATABASE_URL 오류, JWT_SECRET 미설정, Cloud SQL 접근 불가

### Ingress 502 Bad Gateway

- Pod readiness probe 실패 → Pod 로그 확인
- Service selector 불일치 → `kubectl describe svc openclaw-api -n openclaw`

### ManagedCertificate Provisioning 상태 지속

- DNS A 레코드가 Ingress IP를 가리키는지 확인
- 최대 15분 대기, 그래도 안 되면 `kubectl describe managedcertificate`
