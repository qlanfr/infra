# 인프라 구성 문서

이 문서는 **우분투 환경**에서 **minikube**를 이용해 Kubernetes 클러스터를 구축하고, **FastAPI**와 **MySQL** 데이터베이스를 배포한 인프라 구성 내용입니다. 이 구성에서는 **Terraform**을 통해 Kubernetes 리소스를 자동으로 배포하며, FastAPI API 서버와 MySQL 데이터베이스의 연결을 테스트합니다.

---

## 환경 설정

- **운영체제**: Ubuntu 22.04
- **Kubernetes**: Minikube 사용
- **API 서버**: FastAPI
- **데이터베이스**: MySQL

---

## 인프라 구성도

이 프로젝트는 Minikube로 구성된 Kubernetes 클러스터에서 FastAPI와 MySQL을 배포하고, 두 애플리케이션 간의 통신을 통해 API 요청이 DB와 연동되는 구조입니다.

---

## 주요 구성 요소

### 1. Kubernetes 클러스터 설정

- **클러스터 생성**: Minikube를 사용하여 로컬에서 Kubernetes 클러스터를 설정하였습니다.
- **Terraform을 통한 리소스 배포**: Terraform을 사용하여 FastAPI와 MySQL을 배포하는 리소스를 정의하고 관리하였습니다.
- **네트워크 구성**: FastAPI는 `NodePort` 방식으로 외부 접근을 허용하고, MySQL은 `ClusterIP`로 내부에서만 접근 가능하도록 설정하였습니다.

> **Pods 및 Services 상태 확인 스크린샷**
> ![pods](https://github.com/qlanfr/infra/blob/main/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202024-10-27%2016-23-44.png)

---

### 2. FastAPI 배포

- **FastAPI 애플리케이션**은 Docker 이미지를 생성하여 Kubernetes에 배포하였으며, `/health` 엔드포인트를 통해 서버의 상태를 확인할 수 있습니다.
- **NodePort Service**를 통해 외부 IP를 통해 FastAPI API에 접근이 가능합니다.


---

### 3. MySQL 배포

- **MySQL**은 Kubernetes 클러스터 내부에 `ClusterIP` 서비스로 설정되어 FastAPI와 내부 네트워크에서 통신할 수 있습니다.
- **데이터베이스 초기화**: `db-init.sql` 스크립트를 통해 `items` 테이블을 생성하고 초기 데이터 구조를 설정하였습니다.

> **MySQL 데이터베이스 테이블 상태**
> ![db 테이블](https://github.com/qlanfr/infra/blob/main/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202024-10-27%2016-39-01.png)

---

## 시스템 테스트 및 확인

### 1. Health Check

FastAPI 서버가 정상적으로 작동하는지 `/health` 엔드포인트로 확인하였습니다. 정상 작동 시 `"status": "healthy"` 메시지가 반환됩니다.

> **Health Check 결과**
> ![health cheak](https://github.com/qlanfr/api/blob/main/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202024-10-27%2016-24-21.png)

### 2. 데이터베이스 연결 테스트

FastAPI를 통해 MySQL 데이터베이스에 연결하여 CRUD 기능을 테스트했습니다.

- **테이블 상태 확인**: MySQL에서 `items` 테이블이 생성되었고, 데이터를 삽입하고 조회할 수 있는지 확인하였습니다.
- **API 연동 테스트**: FastAPI 엔드포인트를 통해 데이터 생성 및 조회 요청을 보내 MySQL과의 통신이 올바르게 이루어지는지 검증했습니다.

> **API 요청 및 응답 스크린샷**
> ![db<>api](https://github.com/qlanfr/api/blob/main/%EC%8A%A4%ED%81%AC%EB%A6%B0%EC%83%B7%202024-10-27%2016-41-06.png)

---

