# openclaw-manager 배포 가이드

내부 K8s 오케스트레이션 API. **ClusterIP 서비스**로 외부에 노출되지 않으며, [App API](../api/DEPLOY.md)가 내부 DNS를 통해 프록시하여 Flutter 앱에 서비스를 제공한다.

## 내부 통신 구조

```
[Flutter App]
     ↓ HTTPS (JWT 인증)
[openclaw-api :4000]  ← Ingress (외부 공개)
     ↓ HTTP (Bearer API Key)
     ↓ http://openclaw-manager.openclaw.svc.cluster.local:3000
[openclaw-manager :3000]  ← ClusterIP (내부 전용)
     ↓ K8s API (ServiceAccount RBAC)
     ↓ WS RPC (내부 DNS → <instanceId>-openclaw:18789)
[Gateway Pods]  ← ClusterIP (내부 전용)
```

### 통신 경로

| 구간                    | 프로토콜  | 인증 방식                  | 내부 주소                                                |
| ----------------------- | --------- | -------------------------- | -------------------------------------------------------- |
| Flutter App → App API   | HTTPS     | JWT Bearer Token           | `api.openclaw.zazz.buzz:443` (Ingress)                   |
| App API → Manager       | HTTP      | `Bearer <MANAGER_API_KEY>` | `openclaw-manager.openclaw.svc.cluster.local:3000`       |
| Manager → K8s API       | HTTPS     | ServiceAccount Token       | `kubernetes.default.svc`                                 |
| Manager → Gateway (RPC) | WebSocket | Gateway Token              | `<instanceId>-openclaw.openclaw.svc.cluster.local:18789` |

### App API 연결 설정

App API(`deploy/api/`)는 아래 환경변수로 Manager에 연결한다:

```yaml
# deploy/api/k8s/api-deployment.yaml
- name: MANAGER_URL
  value: "http://openclaw-manager.openclaw.svc.cluster.local:3000"
- name: MANAGER_API_KEY
  valueFrom:
    secretKeyRef:
      name: openclaw-api
      key: MANAGER_API_KEY # openclaw-manager Secret의 API_KEY와 동일한 값
```

> `MANAGER_API_KEY`는 Manager의 `openclaw-manager` Secret에 저장된 `API_KEY`와 **반드시 동일한 값**이어야 한다.

## 사전 준비

- GKE 클러스터 접근 (`kubectl` 설정 완료)
- Artifact Registry 접근 (`gcloud auth configure-docker us-central1-docker.pkg.dev`)
- `openclaw` 네임스페이스 생성 완료
- ServiceAccount 및 RBAC 설정 완료

---

## 1. K8s Secret 생성

```bash
kubectl create secret generic openclaw-manager -n openclaw \
  --from-literal=API_KEY="$(openssl rand -base64 32)"
```

---

## 2. RBAC 설정

```bash
kubectl apply -f deploy/manager/k8s/rbac.yaml
```

---

## 3. Docker 이미지 빌드 및 푸시

```bash
cd deploy/manager

# 이미지 빌드
docker build -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-manager:latest .

# Artifact Registry에 푸시
docker push us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-manager:latest
```

---

## 4. K8s 매니페스트 배포

```bash
kubectl apply -f deploy/manager/k8s/manager-deployment.yaml
```

---

## 5. 배포 확인

```bash
# Pod 상태 확인
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-manager

# 로그 확인
kubectl logs -n openclaw -l app.kubernetes.io/name=openclaw-manager -f

# Health check
kubectl exec -n openclaw deploy/openclaw-manager -- wget -qO- http://localhost:3000/health
```

---

## 6. Manager API 직접 테스트

Manager는 ClusterIP 서비스이므로 외부에서 직접 접근할 수 없다. `kubectl port-forward`로 로컬에 포워딩하여 테스트한다.

### 6-0. 포트 포워딩 및 API Key 확인

```bash
# 터미널 1: 포트 포워딩 (로컬 3000 -> Manager 3000)
kubectl port-forward -n openclaw svc/openclaw-manager 3000:3000

# 터미널 2: API Key 확인
export API_KEY=$(kubectl get secret openclaw-manager -n openclaw -o jsonpath='{.data.API_KEY}' | base64 -d)
```

이후 모든 curl 명령에서 `$API_KEY`를 사용한다.

### 6-1. 인스턴스 관리

```bash
# 인스턴스 목록 조회
curl -s http://localhost:3000/api/instances \
  -H "Authorization: Bearer $API_KEY" | jq

# 인스턴스 상세 조회
curl -s http://localhost:3000/api/instances/<USER_ID> \
  -H "Authorization: Bearer $API_KEY" | jq
```

### 6-2. Telegram 봇 토큰 설정

```bash
# 봇 토큰 등록 — 게이트웨이 config.patch RPC를 통해 설정
curl -s -X POST http://localhost:3000/api/instances/<USER_ID>/telegram/setup \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"botToken":"123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11"}' | jq

# 기대 응답
# { "ok": true, "config": { ... } }
```

특정 accountId를 지정하려면:

```bash
curl -s -X POST http://localhost:3000/api/instances/<USER_ID>/telegram/setup \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"botToken":"123456:ABC-DEF...", "accountId":"my-bot"}' | jq
```

### 6-3. Telegram 연결 상태 확인

```bash
# 기본 상태
curl -s http://localhost:3000/api/instances/<USER_ID>/telegram/status \
  -H "Authorization: Bearer $API_KEY" | jq

# probe=true 로 실시간 프로빙
curl -s "http://localhost:3000/api/instances/<USER_ID>/telegram/status?probe=true" \
  -H "Authorization: Bearer $API_KEY" | jq

# 기대 응답
# { "userId": "...", "telegram": { "running": true, ... }, "accounts": ... }
```

> setup 직후에는 게이트웨이가 재시작되므로, 몇 초 대기 후 status를 호출한다.

### 6-4. DM 페어링 요청 조회

Telegram 봇에 DM을 보낸 사용자의 페어링 요청 목록을 조회한다.

```bash
curl -s "http://localhost:3000/api/instances/<USER_ID>/pairing/list?channel=telegram" \
  -H "Authorization: Bearer $API_KEY" | jq

# 기대 응답
# { "channel": "telegram", "requests": [{ "id": "123456", "code": "ABC3KLM9", ... }] }
```

### 6-5. DM 페어링 승인

```bash
curl -s -X POST http://localhost:3000/api/instances/<USER_ID>/pairing/approve \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"channel":"telegram","code":"ABC3KLM9","notify":true}' | jq

# 기대 응답
# { "approved": true, ... }
```

### 6-6. Telegram 연결 해제

```bash
curl -s -X POST http://localhost:3000/api/instances/<USER_ID>/telegram/logout \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{}' | jq

# 기대 응답
# { "channel": "telegram", "cleared": true, "loggedOut": true }
```

### 6-7. WhatsApp QR 요청 (참고)

```bash
curl -s -X POST http://localhost:3000/api/instances/<USER_ID>/whatsapp/qr \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{}' | jq

curl -s http://localhost:3000/api/instances/<USER_ID>/whatsapp/status \
  -H "Authorization: Bearer $API_KEY" | jq
```

---

## E2E 테스트 플로우

### Telegram 채널 연동 전체 플로우

```
1. setup      → POST /api/instances/<USER_ID>/telegram/setup
2. status     → GET  /api/instances/<USER_ID>/telegram/status?probe=true
3. (Telegram 앱에서 봇에 DM 전송)
4. list       → GET  /api/instances/<USER_ID>/pairing/list?channel=telegram
5. approve    → POST /api/instances/<USER_ID>/pairing/approve
6. (봇이 정상 응답하는지 확인)
7. logout     → POST /api/instances/<USER_ID>/telegram/logout
```

---

## 업데이트 배포

```bash
cd deploy/manager

# 1. 이미지 빌드 & 푸시
docker build -t us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-manager:latest .
docker push us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-manager:latest

# 2. Pod 재시작
kubectl rollout restart deployment/openclaw-manager -n openclaw

# 3. 롤아웃 확인
kubectl rollout status deployment/openclaw-manager -n openclaw
```

---

## 환경 변수

| 변수                       | 설명                   | 기본값                                                        |
| -------------------------- | ---------------------- | ------------------------------------------------------------- |
| `PORT`                     | 서버 포트              | `3000`                                                        |
| `OPENCLAW_NAMESPACE`       | K8s 네임스페이스       | `openclaw`                                                    |
| `OPENCLAW_MANAGER_API_KEY` | Bearer 토큰 인증 키    | (필수)                                                        |
| `OPENCLAW_IMAGE_REPO`      | 게이트웨이 이미지 레포 | `us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-gke` |
| `OPENCLAW_IMAGE_TAG`       | 게이트웨이 이미지 태그 | `latest`                                                      |
| `OPENCLAW_DOMAIN_BASE`     | Ingress 도메인         | `openclaw.zazz.buzz`                                          |
| `OPENCLAW_INGRESS_ENABLED` | Ingress 생성 여부      | `false`                                                       |
| `OPENCLAW_GATEWAY_PORT`    | 게이트웨이 포트        | `18789`                                                       |

---

## K8s Service 상세

Manager는 **ClusterIP** 타입으로 배포되며, Ingress 없이 클러스터 내부에서만 접근 가능하다.

```yaml
# deploy/manager/k8s/manager-deployment.yaml (Service 부분)
apiVersion: v1
kind: Service
metadata:
  name: openclaw-manager
  namespace: openclaw
spec:
  type: ClusterIP # 외부 노출 없음
  ports:
    - port: 3000
      targetPort: http
  selector:
    app.kubernetes.io/name: openclaw-manager
```

### 내부 접근 주소

| 형태       | 주소                                               |
| ---------- | -------------------------------------------------- |
| Full DNS   | `openclaw-manager.openclaw.svc.cluster.local:3000` |
| 짧은 DNS   | `openclaw-manager.openclaw:3000`                   |
| 같은 NS 내 | `openclaw-manager:3000`                            |

App API의 `MANAGER_URL`은 Full DNS를 사용한다.

### 내부 통신 확인

```bash
# App API Pod에서 Manager에 접근 가능한지 확인
kubectl exec -n openclaw deploy/openclaw-api -- \
  wget -qO- http://openclaw-manager:3000/health
# {"ok":true}

# Manager에서 Gateway Pod에 RPC 접근 가능한지 확인
kubectl exec -n openclaw deploy/openclaw-manager -- \
  wget -qO- http://hyeok-openclaw:18789/health 2>/dev/null || echo "Gateway에 HTTP health 없음 (WS만 사용)"
```

---

## 트러블슈팅

### Telegram setup 실패 (502)

- 게이트웨이 Pod가 Running 상태인지 확인: `kubectl get pods -n openclaw -l openclaw.ai/user=<USER_ID>`
- 게이트웨이 로그 확인: `kubectl logs -n openclaw -l openclaw.ai/user=<USER_ID> -c gateway`
- Gateway token이 Secret에 있는지 확인: `kubectl get secret <USER_ID>-openclaw -n openclaw -o jsonpath='{.data.OPENCLAW_GATEWAY_TOKEN}'`

### status에서 telegram이 null

- config.patch가 정상 적용되었는지 RPC로 확인:
  ```bash
  curl -s -X POST http://localhost:3000/api/instances/<USER_ID>/rpc \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d '{"method":"config.get","params":{}}' | jq '.payload.config.channels.telegram'
  ```

### pairing list 빈 배열

- Telegram 앱에서 봇에 `/start` 또는 아무 메시지를 보낸 후 재시도
- Pod 내부에서 직접 확인:
  ```bash
  kubectl exec -n openclaw <POD_NAME> -c gateway -- node dist/index.js pairing list telegram --json
  ```

### pairing approve 실패

- code가 정확한지 확인 (대소문자 구분)
- Pod가 Running 상태인지 확인

### App API → Manager 연결 실패 (502/504)

App API에서 Manager 프록시 호출 시 오류가 발생하는 경우:

```bash
# 1. Manager Pod 상태 확인
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-manager

# 2. Manager Service 확인
kubectl get svc openclaw-manager -n openclaw

# 3. App API → Manager DNS 해석 확인
kubectl exec -n openclaw deploy/openclaw-api -- \
  nslookup openclaw-manager.openclaw.svc.cluster.local

# 4. App API → Manager 직접 연결 테스트
kubectl exec -n openclaw deploy/openclaw-api -- \
  wget -qO- http://openclaw-manager:3000/health

# 5. MANAGER_API_KEY 일치 여부 확인
# App API Secret의 MANAGER_API_KEY
kubectl get secret openclaw-api -n openclaw -o jsonpath='{.data.MANAGER_API_KEY}' | base64 -d
# Manager Secret의 API_KEY (위와 동일해야 함)
kubectl get secret openclaw-manager -n openclaw -o jsonpath='{.data.API_KEY}' | base64 -d
```

주요 원인:

- Manager Pod가 CrashLoopBackOff → Manager 로그 확인
- Service selector 불일치 → `kubectl describe svc openclaw-manager -n openclaw`
- `MANAGER_API_KEY`가 Manager의 `API_KEY`와 다름 → Secret 재생성 필요
