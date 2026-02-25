# ============================================================
# OpenClaw Deployment Makefile
# ============================================================
#
# 사용법 (deploy/ 디렉토리에서 실행):
#   make deploy-api          API 빌드 → 푸시 → 롤아웃
#   make deploy-manager      Manager 빌드 → 푸시 → 롤아웃
#   make deploy-web          Flutter Web 빌드 → Docker 빌드 → 푸시 → 롤아웃
#   make deploy-gke          GKE 이미지 빌드(SHA 태그) → 푸시 → Manager 태그 동기화
#   make deploy-all          api + manager + web 순차 배포
#   make build-app-android   Flutter Android appbundle 빌드
#   make build-app-ios       Flutter iOS ipa 빌드
#   make status              클러스터 상태 확인
#
# 옵션:
#   FORCE=1                  확인 프롬프트 스킵
#
# ============================================================

ROOT_DIR      := $(shell cd .. && pwd)
REGISTRY      := us-central1-docker.pkg.dev/learneroid/openclaw
NAMESPACE     := openclaw
PLATFORM      := linux/amd64
GIT_SHA       := $(shell git rev-parse --short HEAD)

API_IMAGE     := $(REGISTRY)/openclaw-api
MANAGER_IMAGE := $(REGISTRY)/openclaw-manager
WEB_IMAGE     := $(REGISTRY)/openclaw-web
GKE_IMAGE     := $(REGISTRY)/openclaw-gke

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "OpenClaw Deployment"
	@echo "==================="
	@echo ""
	@echo "  deploy-api          API 빌드 → 푸시 → 롤아웃"
	@echo "  deploy-manager      Manager 빌드 → 푸시 → 롤아웃"
	@echo "  deploy-web          Flutter Web 빌드 → Docker 빌드 → 푸시 → 롤아웃"
	@echo "  deploy-gke          GKE 이미지 빌드(SHA 태그) → 푸시 → Manager 태그 동기화"
	@echo "  deploy-all          api + manager + web 순차 배포"
	@echo ""
	@echo "  build-api           API Docker 이미지 빌드"
	@echo "  build-manager       Manager Docker 이미지 빌드"
	@echo "  build-web           Flutter Web + Nginx Docker 이미지 빌드"
	@echo "  build-gke           GKE Gateway 이미지 빌드 (태그: $(GIT_SHA))"
	@echo "  build-app-android   Flutter Android appbundle 빌드"
	@echo "  build-app-ios       Flutter iOS ipa 빌드"
	@echo ""
	@echo "  status              클러스터 상태 확인"
	@echo ""
	@echo "옵션: FORCE=1 make <target>  확인 프롬프트 스킵"

# --- 확인 프롬프트 ---
define confirm
	@if [ -z "$(FORCE)" ]; then \
		printf "\033[1;33m⚠ production에 $(1)를 배포합니다. 계속하시겠습니까? [y/N] \033[0m"; \
		read ans; \
		case "$$ans" in [yY]*) ;; *) echo "취소됨."; exit 1 ;; esac; \
	fi
endef

# ============================================================
# API
# ============================================================
.PHONY: build-api push-api deploy-api

build-api:
	docker build --platform $(PLATFORM) -t $(API_IMAGE):latest api

push-api:
	docker push $(API_IMAGE):latest

deploy-api:
	$(call confirm,api)
	$(MAKE) build-api push-api
	kubectl rollout restart deployment/openclaw-api -n $(NAMESPACE)
	kubectl rollout status deployment/openclaw-api -n $(NAMESPACE) --timeout=120s

# ============================================================
# Manager
# ============================================================
.PHONY: build-manager push-manager deploy-manager

build-manager:
	docker build --platform $(PLATFORM) -t $(MANAGER_IMAGE):latest manager

push-manager:
	docker push $(MANAGER_IMAGE):latest

deploy-manager:
	$(call confirm,manager)
	$(MAKE) build-manager push-manager
	kubectl rollout restart deployment/openclaw-manager -n $(NAMESPACE)
	kubectl rollout status deployment/openclaw-manager -n $(NAMESPACE) --timeout=120s

# ============================================================
# Web (Flutter Web + Nginx)
# ============================================================
.PHONY: build-web push-web deploy-web

build-web:
	cd app && flutter build web --release
	rm -rf web/build/web
	cp -r app/build/web web/build/web
	docker build --platform $(PLATFORM) --no-cache -t $(WEB_IMAGE):latest web

push-web:
	docker push $(WEB_IMAGE):latest

deploy-web:
	$(call confirm,web)
	$(MAKE) build-web push-web
	kubectl rollout restart deployment/openclaw-web -n $(NAMESPACE)
	kubectl rollout status deployment/openclaw-web -n $(NAMESPACE) --timeout=120s

# ============================================================
# GKE Gateway (tag-based)
#
# GKE 이미지는 git SHA를 태그로 사용합니다.
# imagePullPolicy: IfNotPresent이므로 고유 태그가 필수입니다.
# 배포 시 Manager의 OPENCLAW_IMAGE_TAG를 자동으로 업데이트합니다.
# ============================================================
.PHONY: build-gke push-gke deploy-gke

build-gke:
	docker build --platform $(PLATFORM) -f $(ROOT_DIR)/Dockerfile.gke -t $(GKE_IMAGE):$(GIT_SHA) $(ROOT_DIR)

push-gke:
	docker push $(GKE_IMAGE):$(GIT_SHA)

deploy-gke:
	$(call confirm,gke)
	$(MAKE) build-gke push-gke
	@echo "GKE 이미지 태그: $(GIT_SHA)"
	@echo "Manager의 OPENCLAW_IMAGE_TAG를 $(GIT_SHA)로 업데이트..."
	kubectl set env deployment/openclaw-manager -n $(NAMESPACE) OPENCLAW_IMAGE_TAG=$(GIT_SHA)
	@echo "Manager가 자동 롤아웃됩니다 (env 변경으로 인한 재시작)"
	kubectl rollout status deployment/openclaw-manager -n $(NAMESPACE) --timeout=120s

# ============================================================
# App (Flutter Mobile)
# ============================================================
.PHONY: build-app-android build-app-ios

build-app-android:
	cd app && flutter build appbundle --release

build-app-ios:
	cd app && flutter build ipa --release

# ============================================================
# 통합 명령어
# ============================================================
.PHONY: deploy-all status

deploy-all:
	$(MAKE) deploy-api
	$(MAKE) deploy-manager
	$(MAKE) deploy-web

status:
	@echo "=== Deployments ==="
	@kubectl get deployments -n $(NAMESPACE)
	@echo ""
	@echo "=== Pods ==="
	@kubectl get pods -n $(NAMESPACE)
	@echo ""
	@echo "=== Manager OPENCLAW_IMAGE_TAG ==="
	@kubectl get deployment/openclaw-manager -n $(NAMESPACE) \
		-o jsonpath='{.spec.template.spec.containers[0].env[?(@.name=="OPENCLAW_IMAGE_TAG")].value}'
	@echo ""
