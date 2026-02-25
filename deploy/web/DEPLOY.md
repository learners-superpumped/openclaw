# Flutter Web 배포 가이드

## 배포 명령어

```bash
# 1) Flutter 웹 빌드
cd deploy/app
flutter build web --release

# 2) 빌드 결과물 복사
rm -rf ../web/build/web
cp -r build/web ../web/build/web

# 3) Docker 이미지 빌드 & 푸시
cd ../web
IMAGE="us-central1-docker.pkg.dev/learneroid/openclaw/openclaw-web"
IMAGE_TAG=$(date +%Y%m%d-%H%M%S)
docker build --no-cache --platform linux/amd64 -t "${IMAGE}:${IMAGE_TAG}" -t "${IMAGE}:latest" .
docker push "${IMAGE}:${IMAGE_TAG}"
docker push "${IMAGE}:latest"

# 4) GKE 배포
kubectl set image deployment/openclaw-web web="${IMAGE}:${IMAGE_TAG}" -n openclaw
kubectl rollout status deployment/openclaw-web -n openclaw
```

> `--no-cache` 플래그를 사용해야 Docker가 이전 빌드 레이어를 재사용하지 않는다.

## 배포 확인

```bash
# 캐시 헤더 & ETag 확인
curl -sI https://app.openclaw.zazz.buzz/main.dart.js

# Pod 상태 확인
kubectl get pods -n openclaw -l app.kubernetes.io/name=openclaw-web
```

---

## 캐시 전략 (nginx.conf)

### 문제: Flutter Web의 캐시 무효화

Flutter Web은 빌드 시 `main.dart.js`라는 **고정된 파일명**을 사용한다.
Webpack 같은 번들러는 `main.a3f2c1.js`처럼 content hash를 파일명에 포함하므로
파일이 변경되면 자동으로 새 URL이 되지만, Flutter는 그렇지 않다.

만약 nginx에서 `*.js`를 모두 `immutable, max-age=1년`으로 캐시하면:

1. 사용자가 최초 방문 시 `main.dart.js`를 다운로드하고 브라우저가 1년간 캐시
2. 새 버전을 배포해도 브라우저는 캐시된 파일을 사용 (서버에 확인조차 안 함)
3. 사용자가 강제 새로고침(Ctrl+Shift+R)을 하지 않는 한 업데이트 불가

### 해결: ETag 기반 revalidation (`no-cache`)

nginx.conf에서 Flutter 핵심 파일들을 `no-cache`로 설정:

```nginx
location ~* ^/(index\.html|main\.dart\.js|flutter\.js|flutter_service_worker\.js|flutter_bootstrap\.js|version\.json|manifest\.json)$ {
    add_header Cache-Control "no-cache" always;
    ...
}
```

`no-cache`는 **"캐시하지 마"가 아니라 "사용 전에 서버에 확인해"** 라는 의미:

```
1차 방문:
  GET /main.dart.js → 200 OK (3.9MB) + ETag: "abc123"
  브라우저가 파일을 캐시에 저장

2차 방문 (변경 없음):
  GET /main.dart.js + If-None-Match: "abc123"
  → 304 Not Modified (~200바이트, 본문 없음)
  → 브라우저가 캐시된 파일 사용

2차 방문 (새 배포):
  GET /main.dart.js + If-None-Match: "abc123"
  → 200 OK (새 파일 전체 다운로드) + ETag: "def456"
```

### Cache-Control 값 비교

| 값                       | 캐시 저장 | 서버 확인          | 재다운로드 |
| ------------------------ | --------- | ------------------ | ---------- |
| `immutable, max-age=1년` | O         | X (1년간 안 함)    | X          |
| `no-cache`               | O         | O (매번 ETag 검증) | 변경시만   |
| `no-store`               | X         | -                  | 매번 전체  |

### 파일별 캐시 전략

| 파일                   | 캐시          | 이유                                      |
| ---------------------- | ------------- | ----------------------------------------- |
| `index.html`           | no-cache      | 진입점, 항상 최신 필요                    |
| `main.dart.js`         | no-cache      | 앱 코드, 고정 파일명                      |
| `flutter_bootstrap.js` | no-cache      | 빌드 설정, 로더 포함                      |
| `flutter.js`           | no-cache      | Flutter 로더                              |
| `version.json`         | no-cache      | 버전 메타데이터                           |
| `canvaskit/*`          | immutable 1년 | engineRevision 기반 CDN URL로 자동 무효화 |
| `assets/*`, `icons/*`  | immutable 1년 | 이미지/폰트 등 정적 리소스                |
