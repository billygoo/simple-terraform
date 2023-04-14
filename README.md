# simple-terraform
iac를 위한 terraform 저장소

## 고려 사항 
- AWS Account를 `account1`, `account2`로 프로파일을 설정해야 한다. 
- Terraform lock 파일이 `dynamoDB Table`로 관리 된다. 


# 디렉토리 구조 
```bash
.
├── Makefile                   # terraform formatting 관련 실행 스크립트
├── README.md
└── infrastructure
    ├── account1               # Account1의 인프라 프로젝트
    │   ├── s3/                # Terraform 상태 관련 프로젝트
    │   ├── tgw/               # TransitGateway 관련 프로젝트
    │   ├── dependencies.tf
    │   ├── eks.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── variables.tf
    │   └── versions.tf
    ├── account2               # Account1의 인프라 프로젝트
    │   ├── dependencies.tf
    │   ├── eks.tf
    │   ├── main.tf
    │   ├── outputs.tf
    │   ├── variables.tf
    │   └── versions.tf
    └── module
        └── vpc                # VPC 모듈
```

# Tip 
- 최상단에 `make` 명령어를 이용해 formating을 수행할 수 있다. 
- `make format`을 이용하면 자동으로 문서의 format이 수정된다. 
```bash
$ make help
Usage:

 check    check terraform files
 format   format terraform files
 help     prints this help message
```
