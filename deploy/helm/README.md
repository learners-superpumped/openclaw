# OpenClaw GKE 배포 가이드

GKE Autopilot 클러스터(`learners`)에 유저별 독립된 OpenClaw 인스턴스를 배포하는 단계별 가이드입니다.

---

## 전체 순서 요약

| #   | 단계                          | 한 줄 설명                                         |
| --- | ----------------------------- | -------------------------------------------------- |
| 1   | Artifact Registry 저장소 생성 | Docker 이미지를 푸시할 곳 만들기                   |
| 2   | GKE 이미지 빌드 & 푸시        | `Dockerfile.gke`로 Chromium 포함 이미지 빌드       |
| 3   | Manager 이미지 빌드 & 푸시    | `deploy/manager/Dockerfile`로 관리 API 이미지 빌드 |
| 4   | 네임스페이스 생성             | `openclaw` 네임스페이스                            |
| 5   | DNS 설정                      | `*.openclaw.zazz.buzz` 와일드카드 레코드           |
| 6   | RBAC 적용                     | Manager의 ServiceAccount, Role, RoleBinding        |
| 7   | Manager 배포                  | Manager API 서비스를 클러스터에 배포               |
| 8   | 유저 인스턴스 생성            | API 또는 Helm으로 유저별 인스턴스 배포             |
| 9   | WhatsApp 연동                 | QR 코드 생성 → 스캔 → 연결 완료                    |
| 10  | 검증                          | Pod 상태, 인증서, 브라우저 접속 확인               |

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

## Step 5. DNS 설정

`*.openclaw.zazz.buzz` 와일드카드 A 레코드가 필요합니다.

GKE Ingress가 생성되면 외부 IP가 할당되는데, 처음에는 IP를 모르므로:

1. 먼저 Step 8까지 진행하여 Ingress를 하나 생성
2. 할당된 IP 확인: `kubectl get ingress -n openclaw`
3. DNS에 `*.openclaw.zazz.buzz → <할당된 IP>` A 레코드 추가

> 또는 이미 고정 IP가 있으면 먼저 설정해도 됩니다.

## Step 6. RBAC 적용

Manager가 K8s 리소스를 생성/삭제할 수 있도록 권한을 부여합니다.

```bash
kubectl apply -f deploy/manager/k8s/rbac.yaml
```

생성되는 리소스:

- ServiceAccount `openclaw-manager`
- Role (Deployment, Service, Secret, PVC, Ingress, ManagedCertificate CRUD)
- RoleBinding

## Step 7. Manager 배포

```bash
kubectl apply -f deploy/manager/k8s/manager-deployment.yaml
```

배포 확인:

```bash
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-manager
# STATUS가 Running이면 성공

# 헬스체크
kubectl exec -n openclaw deploy/openclaw-manager -- curl -s http://localhost:3000/health
# {"ok":true}
```

## Step 8. 유저 인스턴스 생성

### 방법 A: Manager API 사용 (권장)

```bash
# Manager에 포트포워딩 (로컬에서 API 호출용)
kubectl port-forward -n openclaw svc/openclaw-manager 3000:3000 &

# 인스턴스 생성
curl -X POST http://localhost:3000/api/instances \
  -H 'Content-Type: application/json' \
  -d '{
    "userId": "alice",
    "secrets": {
      "ANTHROPIC_API_KEY": "sk-ant-..."
    }
  }'
```

응답에 `gatewayToken`이 포함됩니다 (자동 생성).

Pod이 Ready 될 때까지 대기:

```bash
kubectl get pods -n openclaw -l openclaw.ai/user=alice -w
# STATUS가 Running, READY 1/1이면 완료
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
# 1. QR 코드 생성
curl -X POST http://localhost:3000/api/instances/alice/whatsapp/qr \
  -H 'Content-Type: application/json' \
  -d '{"force": true}'
# 응답의 qrDataUrl을 브라우저에서 열거나 <img>로 표시

# 2. 유저가 WhatsApp → Linked Devices에서 QR 스캔

# 3. 연결 대기 (스캔할 때까지 블로킹)
curl -X POST http://localhost:3000/api/instances/alice/whatsapp/wait \
  -H 'Content-Type: application/json' \
  -d '{"timeoutMs": 120000}'
# {"connected": true, "message": "..."} 이면 성공

# 4. 연결 상태 확인
curl http://localhost:3000/api/instances/alice/whatsapp/status
```

## Step 10. 검증

### Pod & 리소스 상태

```bash
kubectl get pods,svc,ingress,managedcertificate -n openclaw -l openclaw.ai/user=alice
```

### ManagedCertificate (TLS) 확인

```bash
kubectl get managedcertificate -n openclaw
# STATUS가 Active이면 HTTPS 사용 가능 (프로비저닝에 10~15분 소요)
```

### 브라우저 화면 확인 (NoVNC)

```bash
kubectl port-forward -n openclaw deploy/alice-openclaw 6080:6080
# 브라우저에서 http://localhost:6080 접속
```

### 게이트웨이 접속 테스트

```bash
# 인증서 프로비저닝 전 (클러스터 내부)
kubectl exec -n openclaw deploy/openclaw-manager -- \
  curl -s http://alice-openclaw.openclaw:18789/

# 인증서 프로비저닝 후 (외부)
curl https://alice.openclaw.zazz.buzz/
```

### 로그 확인

```bash
kubectl logs -n openclaw -l openclaw.ai/user=alice -f
```

---

## 추가 운영

### 인스턴스 목록

```bash
curl http://localhost:3000/api/instances
```

### 인스턴스 삭제

```bash
# PVC 보존 (데이터 유지, 재생성 시 복원됨)
curl -X DELETE http://localhost:3000/api/instances/alice

# PVC도 삭제 (데이터 완전 삭제)
curl -X DELETE "http://localhost:3000/api/instances/alice?preservePvc=false"
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

## 아키텍처

```
[별도 앱 / curl]
       ↓ REST API (포트 3000)
[openclaw-manager]  ← ClusterIP Service
       ↓ K8s API (RBAC)         ↓ WebSocket RPC
[K8s Resources]            [OpenClaw Gateway Pod]
  Deployment, Service,       Chromium (non-headless)
  Ingress, PVC, Secret,     ↕ WhatsApp (Baileys)
  ConfigMap, ManagedCert     NoVNC (포트 6080)
```

### 리소스 네이밍

| 리소스                                                       | 이름 패턴                |
| ------------------------------------------------------------ | ------------------------ |
| Deployment, Service, Ingress, Secret, ConfigMap, ManagedCert | `<userId>-openclaw`      |
| PVC                                                          | `<userId>-openclaw-data` |
| Manager                                                      | `openclaw-manager`       |

### 파일 구조

```
deploy/
├── helm/
│   ├── openclaw/          # Helm chart
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   └── templates/     # K8s 템플릿
│   ├── users/             # 유저별 values 파일
│   └── README.md          # 이 문서
├── manager/
│   ├── src/               # Manager API 소스
│   ├── k8s/               # Manager 배포 매니페스트
│   ├── Dockerfile
│   ├── package.json
│   └── tsconfig.json
└── scripts/
    ├── deploy-user.sh     # Helm 래퍼 스크립트
    └── gke-entrypoint.sh  # GKE 컨테이너 엔트리포인트
```
