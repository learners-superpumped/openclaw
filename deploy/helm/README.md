# OpenClaw GKE 배포 가이드

GKE Autopilot 클러스터(`learners`)에 유저별 독립된 OpenClaw 인스턴스를 배포하는 단계별 가이드입니다.

---

## 전체 순서 요약

| #   | 단계                          | 한 줄 설명                                         |
| --- | ----------------------------- | -------------------------------------------------- |
| 1   | Artifact Registry 저장소 생성 | Docker 이미지를 푸시할 곳 만들기                   |
| 2   | GKE 이미지 빌드 & 푸시        | `Dockerfile.gke`로 Chromium 포함 이미지 빌드       |
| 3   | Manager 이미지 빌드 & 푸시    | `deploy/manager/Dockerfile`로 관리 API 이미지 빌드 |
| 3.5 | App API 이미지 빌드 & 푸시    | `deploy/api/Dockerfile`로 NestJS API 이미지 빌드   |
| 4   | 네임스페이스 생성             | `openclaw` 네임스페이스                            |
| 5   | RBAC 적용                     | Manager의 ServiceAccount, Role, RoleBinding        |
| 6   | Manager API Key 생성          | Manager 인증용 Secret 생성                         |
| 6.5 | App API Secret 생성           | DB, JWT, OAuth 인증 정보 Secret 생성               |
| 7   | Manager 배포                  | Manager API 서비스를 클러스터에 배포               |
| 7.5 | App API 배포                  | NestJS API + Prisma 마이그레이션                   |
| 8   | 유저 인스턴스 생성            | API 또는 Helm으로 유저별 인스턴스 배포             |
| 9   | WhatsApp/Telegram 연동        | QR 스캔 또는 봇 토큰 설정 → 페어링                 |
| 10  | 검증                          | Pod 상태, NetworkPolicy, 프록시 접속 확인          |

---

## Step 1. Artifact Registry 저장소 생성

이미지를 푸시할 Docker 저장소가 없으면 먼저 생성합니다.

```bash
# 이미 있으면 스킵
gcloud artifacts repositories create openclaw \
  --repository-format=docker \
  --location=us-central1 \
  --project=learneroid
```

로컬에서 푸시할 수 있도록 인증 설정:

```bash
gcloud auth configure-docker us-central1-docker.pkg.dev
```

## Step 2. GKE 게이트웨이 이미지 빌드 & 푸시

프로젝트 루트에서 실행합니다. `Dockerfile.gke`는 Chromium + Xvfb + VNC/NoVNC가 포함된 GKE 전용 이미지입니다.

GKE Autopilot은 amd64 노드를 사용하므로 Apple Silicon(M1/M2/M3/M4) Mac에서는 반드시 `--platform`을 지정해야 합니다.

```bash
docker build --platform linux/amd64 -f Dockerfile.gke \
  -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-gke:latest .

docker push us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-gke:latest
```

> 크로스 빌드이므로 QEMU 에뮬레이션으로 시간이 오래 걸립니다. Docker Desktop의 경우 QEMU가 기본 포함되어 있습니다.

## Step 3. Manager API 이미지 빌드 & 푸시

```bash
cd deploy/manager
npm install
npm run build
docker build --platform linux/amd64 \
  -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-manager:latest .
docker push us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-manager:latest
cd ../..
```

## Step 4. 네임스페이스 생성

```bash
kubectl create namespace openclaw
```

클러스터 컨텍스트 확인:

```bash
kubectl config current-context
# 기대값: gke_learneroid_us-central1_learners
```

## Step 5. RBAC 적용

Manager가 K8s 리소스를 생성/삭제할 수 있도록 권한을 부여합니다.

```bash
kubectl apply -f deploy/manager/k8s/rbac.yaml
```

생성되는 리소스:

- ServiceAccount `openclaw-manager`
- Role (Deployment, Service, Secret, PVC, Ingress, NetworkPolicy, ManagedCertificate CRUD)
- RoleBinding

## Step 6. Manager API Key 생성

Manager API 인증에 사용할 Secret을 생성합니다.

```bash
# 안전한 랜덤 키 생성
API_KEY=$(openssl rand -base64 32)
echo "Generated API Key: $API_KEY"  # 이 값을 안전하게 보관하세요

# K8s Secret 생성
kubectl create secret generic openclaw-manager \
  -n openclaw \
  --from-literal=API_KEY="$API_KEY"
```

> 이 API Key는 모든 Manager API 호출에 `Authorization: Bearer <key>` 헤더로 사용됩니다. 안전하게 보관하세요.

## Step 6.5. App API Secret 생성

App API에 필요한 환경변수를 Secret으로 생성합니다.

```bash
kubectl create secret generic openclaw-api \
  -n openclaw \
  --from-literal=DATABASE_URL="postgresql://user:pass@host:5432/openclaw" \
  --from-literal=JWT_SECRET="$(openssl rand -base64 32)" \
  --from-literal=MANAGER_URL="http://openclaw-manager:3000" \
  --from-literal=MANAGER_API_KEY="<Step 6에서 생성한 API Key>" \
  --from-literal=GOOGLE_CLIENT_ID="<Google OAuth Web Client ID>" \
  --from-literal=APPLE_CLIENT_ID="<Apple Service ID>" \
  --from-literal=OPENROUTER_MANAGEMENT_KEY="<OpenRouter 관리 키>"
```

> 자세한 내용은 [`deploy/api/DEPLOY.md`](../api/DEPLOY.md) 참조

## Step 7. Manager 배포

```bash
kubectl apply -f deploy/manager/k8s/manager-deployment.yaml
```

배포 확인:

```bash
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-manager
# STATUS가 Running이면 성공
```

헬스체크 (인증 불필요):

```bash
# Manager에 포트포워딩
kubectl port-forward -n openclaw svc/openclaw-manager 3000:3000 &

curl http://localhost:3000/health
# {"ok":true}
```

> 이후 Step 8~10의 모든 API 호출도 이 포트포워딩을 통해 수행합니다.

### 환경변수 설정

`manager-deployment.yaml`에서 설정하는 환경변수:

| 변수                       | 설명                           | 기본값               |
| -------------------------- | ------------------------------ | -------------------- |
| `OPENCLAW_MANAGER_API_KEY` | API 인증 키 (Secret에서 주입)  | (필수)               |
| `OPENCLAW_INGRESS_ENABLED` | Gateway Ingress 공개 노출 여부 | `"false"`            |
| `OPENCLAW_NAMESPACE`       | K8s 네임스페이스               | `openclaw`           |
| `OPENCLAW_IMAGE_REPO`      | Gateway 이미지 저장소          | (값 참조)            |
| `OPENCLAW_IMAGE_TAG`       | Gateway 이미지 태그            | `latest`             |
| `OPENCLAW_DOMAIN_BASE`     | 도메인 베이스                  | `openclaw.zazz.buzz` |

## Step 7.5. App API 배포

Prisma 마이그레이션 실행 후 API 서비스를 배포합니다.

```bash
cd deploy/api

# 1. 이미지 빌드 & 푸시
docker build --platform linux/amd64 \
  -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest .
docker push us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-api:latest

cd ../..

# 2. 배포 (K8s 매니페스트 또는 Helm)
kubectl apply -f deploy/api/k8s/api-deployment.yaml

# 3. Prisma 마이그레이션 (Pod 내에서 실행)
kubectl exec -n openclaw deploy/openclaw-api -- npx prisma migrate deploy
```

배포 확인:

```bash
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-api
curl https://api.openclaw.app/health
# {"ok":true}
```

Swagger UI (개발 환경만): `https://api.openclaw.app/docs`

> 상세 가이드: [`deploy/api/DEPLOY.md`](../api/DEPLOY.md)

## Step 8. 유저 인스턴스 생성

### 방법 A: Manager API 사용 (권장)

```bash
# Manager에 포트포워딩 (로컬에서 API 호출용)
kubectl port-forward -n openclaw svc/openclaw-manager 3000:3000 &

# API Key 설정 (Step 6에서 생성한 키)
export API_KEY="<your-api-key>"

# 인스턴스 생성
curl -X POST http://localhost:3000/api/instances \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{
    "userId": "alice",
    "secrets": {
      "ANTHROPIC_API_KEY": "sk-ant-..."
    }
  }'
```

> Gateway는 기본적으로 공개 Ingress 없이 배포됩니다. Manager API의 RPC 프록시와 VNC 프록시를 통해서만 접근할 수 있습니다.

Pod이 Ready 될 때까지 대기:

```bash
# kubectl로 직접 확인
kubectl get pods -n openclaw -l openclaw.ai/user=alice -w
# STATUS가 Running, READY 1/1이면 완료

# 또는 Manager API로 폴링 (앱에서 사용)
curl -H "Authorization: Bearer $API_KEY" http://localhost:3000/api/instances/alice
# phase가 "pending" → "starting" → "running" 순서로 변화
```

### 방법 B: Helm 사용

```bash
# values 파일 준비
cp deploy/helm/users/user-example.yaml deploy/helm/users/alice.yaml
# alice.yaml에서 userId, secrets 수정

# 배포
bash deploy/scripts/deploy-user.sh install alice deploy/helm/users/alice.yaml
```

## Step 9. WhatsApp 연동

인스턴스가 Running 상태가 된 후:

```bash
# API Key 설정
export API_KEY="<your-api-key>"

# 1. QR 코드 생성
curl -X POST http://localhost:3000/api/instances/alice/whatsapp/qr \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"force": true}'
# 응답의 qrDataUrl을 브라우저에서 열거나 <img>로 표시

# 2. 유저가 WhatsApp → Linked Devices에서 QR 스캔

# 3. 연결 대기 (스캔할 때까지 블로킹)
curl -X POST http://localhost:3000/api/instances/alice/whatsapp/wait \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"timeoutMs": 120000}'
# {"connected": true, "message": "..."} 이면 성공

# 4. 연결 상태 확인
curl -H "Authorization: Bearer $API_KEY" \
  http://localhost:3000/api/instances/alice/whatsapp/status
```

## Step 9.5. Telegram 연동

인스턴스가 Running 상태가 된 후:

```bash
# 1. Telegram 봇 토큰 설정 (BotFather에서 발급받은 토큰)
curl -X POST http://localhost:3000/api/instances/alice/telegram/setup \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"botToken":"123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"}'

# 2. 연결 상태 확인 (몇 초 대기 후)
curl "http://localhost:3000/api/instances/alice/telegram/status?probe=true" \
  -H "Authorization: Bearer $API_KEY"

# 3. (Telegram 앱에서 봇에 DM 전송)

# 4. 페어링 요청 조회
curl "http://localhost:3000/api/instances/alice/pairing/list?channel=telegram" \
  -H "Authorization: Bearer $API_KEY"

# 5. 페어링 승인
curl -X POST http://localhost:3000/api/instances/alice/pairing/approve \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"channel":"telegram","code":"ABC3KLM9","notify":true}'
```

> Manager의 Telegram API 상세 문서: [`deploy/manager/DEPLOY.md`](../manager/DEPLOY.md)

## Step 10. 검증

### Pod & 리소스 상태

```bash
kubectl get pods,svc,networkpolicy -n openclaw -l openclaw.ai/user=alice
```

### NetworkPolicy 확인

```bash
kubectl get networkpolicy -n openclaw
# 각 유저 인스턴스에 대해 NetworkPolicy가 생성되어 있어야 합니다
```

### RPC 프록시 확인

```bash
# Gateway 상태 조회 (Manager를 통한 프록시)
curl -X POST http://localhost:3000/api/instances/alice/rpc \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"method": "status"}'
```

### 브라우저 화면 확인 (VNC WebSocket 프록시)

```bash
# wscat으로 VNC WebSocket 연결 테스트
npx wscat -c "ws://localhost:3000/api/instances/alice/vnc?token=$API_KEY"
```

또는 kubectl port-forward로 직접 접근:

```bash
kubectl port-forward -n openclaw deploy/alice-openclaw 6080:6080
# 브라우저에서 http://localhost:6080 접속
```

### API 인증 확인

```bash
# 인증 없이 호출 → 401
curl http://localhost:3000/api/instances
# {"error":"Missing or invalid Authorization header"}

# 인증 헤더 포함 → 200
curl -H "Authorization: Bearer $API_KEY" http://localhost:3000/api/instances
```

### Ingress 비활성화 확인

```bash
# Helm 템플릿에서 Ingress가 생성되지 않는지 확인
helm template test deploy/helm/openclaw/ -f deploy/helm/users/user-example.yaml | grep -c "kind: Ingress"
# 0
```

### 로그 확인

```bash
kubectl logs -n openclaw -l openclaw.ai/user=alice -f
```

---

## 추가 운영

### 인스턴스 목록

```bash
curl -H "Authorization: Bearer $API_KEY" http://localhost:3000/api/instances
```

### 인스턴스 상태 상세 조회

인스턴스 생성 후 폴링하여 진행 상태를 확인할 수 있습니다:

```bash
curl -H "Authorization: Bearer $API_KEY" http://localhost:3000/api/instances/alice
```

응답 예시:

```json
{
  "userId": "alice",
  "ready": true,
  "phase": "running",
  "pods": [
    {
      "name": "alice-openclaw-xxxx",
      "phase": "Running",
      "ready": true,
      "restartCount": 0,
      "state": { "status": "running", "startedAt": "2026-02-13T05:30:00Z" },
      "conditions": {
        "scheduled": true,
        "initialized": true,
        "containersReady": true,
        "ready": true
      },
      "createdAt": "2026-02-13T05:29:50Z"
    }
  ]
}
```

**`phase` 필드** (앱에서 사용할 요약 상태):

| phase        | 의미                                  | 앱 표시 예시            |
| ------------ | ------------------------------------- | ----------------------- |
| `"pending"`  | Pod 스케줄링/이미지 풀 대기 중        | "인스턴스 준비 중..."   |
| `"starting"` | 컨테이너 시작됨, readiness probe 대기 | "게이트웨이 시작 중..." |
| `"running"`  | Ready, 정상 동작                      | "실행 중"               |
| `"error"`    | CrashLoopBackOff, ImagePullBackOff 등 | "오류 발생: {message}"  |
| `"unknown"`  | Pod 없음 또는 알 수 없는 상태         | "상태 확인 중..."       |

에러 상태일 때 최상위에 `message` 필드가 추가됩니다:

```json
{ "phase": "error", "message": "back-off 5m0s restarting failed container..." }
```

### 인스턴스 삭제

```bash
# PVC 보존 (데이터 유지, 재생성 시 복원됨)
curl -X DELETE -H "Authorization: Bearer $API_KEY" \
  http://localhost:3000/api/instances/alice

# PVC도 삭제 (데이터 완전 삭제)
curl -X DELETE -H "Authorization: Bearer $API_KEY" \
  "http://localhost:3000/api/instances/alice?preservePvc=false"
```

### 범용 RPC 프록시

Gateway의 모든 RPC 메서드를 Manager를 통해 호출할 수 있습니다:

```bash
# 스크린샷
curl -X POST http://localhost:3000/api/instances/alice/rpc \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"method": "browser.screenshot"}'

# 채널 상태 조회
curl -X POST http://localhost:3000/api/instances/alice/rpc \
  -H "Authorization: Bearer $API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"method": "channel.status", "params": {"channelId": "whatsapp"}}'
```

### Pod 재시작

```bash
kubectl rollout restart deployment alice-openclaw -n openclaw
```

### Helm으로 수동 관리

```bash
bash deploy/scripts/deploy-user.sh status alice    # 상태
bash deploy/scripts/deploy-user.sh delete alice    # 삭제 (PVC 보존)
bash deploy/scripts/deploy-user.sh purge alice     # 완전 삭제
```

---

## API 엔드포인트

### Manager API (내부, ClusterIP:3000)

인증: `Authorization: Bearer <MANAGER_API_KEY>`

| 메서드 | 경로                                     | 설명                    |
| ------ | ---------------------------------------- | ----------------------- |
| POST   | `/api/instances`                         | 인스턴스 생성           |
| GET    | `/api/instances`                         | 인스턴스 목록           |
| GET    | `/api/instances/:userId`                 | 인스턴스 상태 상세 조회 |
| DELETE | `/api/instances/:userId`                 | 인스턴스 삭제           |
| POST   | `/api/instances/:userId/whatsapp/qr`     | WhatsApp QR 코드 생성   |
| POST   | `/api/instances/:userId/whatsapp/wait`   | WhatsApp 연결 대기      |
| GET    | `/api/instances/:userId/whatsapp/status` | WhatsApp 연결 상태      |
| POST   | `/api/instances/:userId/telegram/setup`  | Telegram 봇 토큰 설정   |
| GET    | `/api/instances/:userId/telegram/status` | Telegram 연결 상태      |
| POST   | `/api/instances/:userId/telegram/logout` | Telegram 연결 해제      |
| GET    | `/api/instances/:userId/pairing/list`    | 페어링 요청 조회        |
| POST   | `/api/instances/:userId/pairing/approve` | 페어링 승인             |
| POST   | `/api/instances/:userId/rpc`             | 범용 Gateway RPC 프록시 |
| GET    | `/api/instances/:userId/vnc?token=<key>` | VNC WebSocket 프록시    |
| GET    | `/health`                                | 헬스체크 (인증 불필요)  |

### App API (외부, 포트 4000, api.openclaw.app)

인증: `Authorization: Bearer <JWT>` (로그인 엔드포인트는 인증 불필요)

| 메서드 | 경로                                           | 인증 | 설명                  |
| ------ | ---------------------------------------------- | ---- | --------------------- |
| POST   | `/auth/signup`                                 | -    | 이메일 회원가입       |
| POST   | `/auth/login`                                  | -    | 이메일 로그인         |
| POST   | `/auth/google`                                 | -    | Google 소셜 로그인    |
| POST   | `/auth/apple`                                  | -    | Apple 소셜 로그인     |
| POST   | `/auth/refresh`                                | -    | JWT 토큰 갱신         |
| GET    | `/users/me`                                    | JWT  | 내 프로필 조회        |
| POST   | `/instances`                                   | JWT  | 인스턴스 생성         |
| GET    | `/instances`                                   | JWT  | 내 인스턴스 목록      |
| GET    | `/instances/:id`                               | JWT  | 인스턴스 상세 조회    |
| DELETE | `/instances/:id`                               | JWT  | 인스턴스 삭제         |
| POST   | `/instances/:id/telegram/setup`                | JWT  | Telegram 봇 토큰 설정 |
| GET    | `/instances/:id/telegram/status`               | JWT  | Telegram 연결 상태    |
| POST   | `/instances/:id/telegram/logout`               | JWT  | Telegram 연결 해제    |
| GET    | `/instances/:id/pairing/list?channel=telegram` | JWT  | 페어링 요청 조회      |
| POST   | `/instances/:id/pairing/approve`               | JWT  | 페어링 승인           |
| POST   | `/instances/:id/whatsapp/qr`                   | JWT  | WhatsApp QR 요청      |
| POST   | `/instances/:id/whatsapp/wait`                 | JWT  | WhatsApp 연결 대기    |
| GET    | `/instances/:id/whatsapp/status`               | JWT  | WhatsApp 연결 상태    |
| POST   | `/instances/:id/rpc`                           | JWT  | RPC 호출              |
| GET    | `/health`                                      | -    | 헬스체크              |

---

## 아키텍처

```
[Flutter App (ClawBox)]
     ↓ HTTPS (JWT 인증)
[openclaw-api]  ← 외부 노출 (포트 4000, api.openclaw.app)
     │  NestJS + Prisma + JWT
     │  인증, 인스턴스 관리, 구독 검증
     ↓ REST API + Bearer Token (포트 3000, ClusterIP)
[openclaw-manager]  ← 내부 전용
     ↓ K8s API        ↓ WS RPC (내부 DNS)     ↓ WS VNC (내부 DNS)
[K8s Resources]   [Gateway :18789]         [NoVNC :6080]
                   (Ingress 없음)           (Service 내부만)
```

- **App API**: 외부에 노출되는 유일한 공개 서비스. JWT 인증, 소셜 로그인(Google/Apple), 인스턴스/Telegram 관리
- **Manager**: 내부 ClusterIP. K8s 오케스트레이션 담당. App API가 프록시하여 호출
- **Gateway**: 공개 Ingress 없음, ClusterIP로만 접근 (Manager가 RPC 프록시)
- **VNC**: Service에 포트 추가되지만 ClusterIP → Manager만 접근
- **NetworkPolicy**: Pod 레벨에서 Manager 외 트래픽 차단 (심층 방어)

### 보안 계층

| 계층               | 보호 대상        | 메커니즘                       |
| ------------------ | ---------------- | ------------------------------ |
| JWT 인증           | App API          | Google/Apple OAuth → JWT 발급  |
| API Key 인증       | Manager API      | `Authorization: Bearer <key>`  |
| Ingress 비활성화   | Gateway 포트     | Ingress 리소스 미생성          |
| NetworkPolicy      | Pod 네트워크     | Manager Pod에서만 접근 허용    |
| ClusterIP          | Service 네트워크 | 클러스터 외부 노출 없음        |
| Token Auto-Refresh | 앱 세션          | 15분 access + 7일 refresh 토큰 |

### 리소스 네이밍

| 리소스                                                | 이름 패턴                |
| ----------------------------------------------------- | ------------------------ |
| Deployment, Service, Secret, ConfigMap, NetworkPolicy | `<userId>-openclaw`      |
| PVC                                                   | `<userId>-openclaw-data` |
| Manager                                               | `openclaw-manager`       |

> Ingress와 ManagedCertificate는 `OPENCLAW_INGRESS_ENABLED=true`인 경우에만 생성됩니다.

### 파일 구조

```
deploy/
├── api/                   # App API (NestJS) — 외부 공개 서비스
│   ├── src/
│   │   ├── main.ts               # NestJS 부트스트랩 (포트 4000)
│   │   ├── app.module.ts         # 루트 모듈
│   │   ├── auth/                 # 인증 (JWT, Google, Apple)
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── auth.guard.ts
│   │   │   └── dto/              # GoogleAuthDto, AppleAuthDto 등
│   │   ├── users/                # 유저 프로필
│   │   ├── instances/            # 인스턴스 관리 + Telegram/WhatsApp
│   │   │   ├── instances.controller.ts
│   │   │   └── instances.service.ts
│   │   ├── manager/              # Manager API 프록시 서비스
│   │   ├── openrouter/           # OpenRouter 관리 키
│   │   └── prisma/               # Prisma 서비스 (컴포지션 패턴)
│   ├── prisma/
│   │   └── schema.prisma         # User, Instance, OpenRouterKey
│   ├── Dockerfile
│   ├── DEPLOY.md                 # API 배포 가이드
│   └── package.json
├── app/                   # Flutter App (ClawBox) — iOS/Android/macOS
│   ├── lib/
│   │   ├── main.dart             # 앱 진입점 (Riverpod + GoRouter)
│   │   ├── constants.dart        # API URL, RevenueCat Key, OAuth ID
│   │   ├── router.dart           # GoRouter 라우팅 + 리다이렉트 가드
│   │   ├── theme/                # 다크 미니멀 디자인 시스템
│   │   ├── models/               # User, AuthTokens, Instance, PairingRequest
│   │   ├── services/             # ApiClient, AuthService, AuthInterceptor
│   │   ├── providers/            # Riverpod 상태관리 (auth, instance, subscription)
│   │   └── screens/              # 7개 스크린 (paywall → dashboard)
│   ├── android/
│   ├── ios/
│   ├── macos/
│   └── pubspec.yaml
├── helm/
│   ├── openclaw/          # Helm chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/     # K8s 템플릿
│   │       ├── deployment.yaml
│   │       ├── service.yaml
│   │       ├── configmap.yaml
│   │       ├── secret.yaml
│   │       ├── pvc.yaml
│   │       ├── network-policy.yaml   # 심층 방어
│   │       ├── ingress.yaml          # 조건부 (ingress.enabled)
│   │       └── managed-certificate.yaml  # 조건부
│   ├── users/             # 유저별 values 파일
│   └── README.md          # 이 문서
├── manager/
│   ├── src/
│   │   ├── index.ts              # Express 앱 + WS upgrade
│   │   ├── config.ts             # 환경변수 설정
│   │   ├── middleware/
│   │   │   └── auth.ts           # API 인증 미들웨어
│   │   ├── routes/
│   │   │   ├── instances.ts      # CRUD 엔드포인트
│   │   │   ├── whatsapp.ts       # WhatsApp 연동
│   │   │   ├── telegram.ts       # Telegram 연동
│   │   │   ├── pairing.ts        # DM 페어링
│   │   │   ├── gateway-proxy.ts  # 범용 RPC 프록시
│   │   │   └── vnc-proxy.ts      # VNC WebSocket 프록시
│   │   └── services/
│   │       ├── k8s-client.ts     # K8s API 래퍼
│   │       ├── k8s-resource-builder.ts  # 리소스 빌더
│   │       ├── gateway-rpc.ts    # Gateway WS RPC 클라이언트
│   │       └── instance-auth.ts  # 인스턴스 인증 공통 모듈
│   ├── k8s/               # Manager 배포 매니페스트
│   ├── Dockerfile
│   ├── DEPLOY.md          # Manager 배포 가이드
│   ├── package.json
│   └── tsconfig.json
└── scripts/
    ├── deploy-user.sh     # Helm 래퍼 스크립트
    └── gke-entrypoint.sh  # GKE 컨테이너 엔트리포인트
```
