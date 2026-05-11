# Bootpay Ruby SDK 테스트 가이드

## 실행

```bash
# 의존성 설치
bundle install

# 전체 테스트
bundle exec rspec

# 특정 파일
bundle exec rspec spec/pg/payment_spec.rb

# 특정 example (라인 지정)
bundle exec rspec spec/pg/payment_spec.rb:5
```

## 디렉토리 구조

```
spec/
├── spec_helper.rb              # 공통 헬퍼 (.env 로딩, 키 분리, create_pg_api 등)
├── pg/                         # PG API 테스트
│   ├── payment_spec.rb
│   ├── billing_spec.rb
│   ├── cancel_spec.rb
│   ├── cash_receipt_spec.rb
│   ├── auth_spec.rb
│   ├── token_spec.rb           # dual-mode-explicit
│   ├── legacy_compatibility_spec.rb  # legacy 전용
│   └── ...
└── commerce/                   # Commerce API 테스트
    ├── token_spec.rb
    ├── user_spec.rb
    ├── product_spec.rb
    ├── order_spec.rb
    └── store_spec.rb
```

## .env 설정

키는 `.env` 또는 환경변수로 주입한다 (`.env.example` 참고). `.env` 가 없으면 production 키로 fallback.

```env
BOOTPAY_ENV=production
BOOTPAY_AUTH_MODE=new

# PG ck/sk
BOOTPAY_PG_CLIENT_KEY_PROD=...
BOOTPAY_PG_SECRET_KEY_PROD=...

# PG legacy (호환성 검증용)
BOOTPAY_PG_APPLICATION_ID_PROD=...
BOOTPAY_PG_PRIVATE_KEY_PROD=...

# Commerce
BOOTPAY_COMMERCE_CLIENT_KEY_PROD=...
BOOTPAY_COMMERCE_SECRET_KEY_PROD=...
```

## PG 인증 방식 토글 (BOOTPAY_AUTH_MODE)

PG 테스트는 기본적으로 신규 `client_key/secret_key` 방식으로 동작한다. 매 실행 시 환경변수로 레거시 `application_id/private_key` 방식으로 전환할 수 있다.

### 토글 contract

| `BOOTPAY_AUTH_MODE` | 동작 |
|---|---|
| `new` (기본, 미설정 시 동일) | `Bootpay::Api.new(client_key:, secret_key:, mode:)` 로 인스턴스 생성. Basic Auth 헤더 자동 부착. |
| `legacy` | `Bootpay::Api.new(application_id:, private_key:, mode:)` 로 인스턴스 생성. `get_access_token` 호출 후 `Bearer` 헤더 사용. |

키 값은 모두 `.env` (또는 환경변수) 로 주입한다 — `.env.example` 참고.

### 사용법

```bash
# (1) 기본 — env var 생략 (= new)
bundle exec rspec spec/pg/payment_spec.rb

# (2) 한 번만 legacy 로 전환
BOOTPAY_AUTH_MODE=legacy bundle exec rspec spec/pg/payment_spec.rb

# (3) 셸 세션 동안 legacy 고정
export BOOTPAY_AUTH_MODE=legacy
bundle exec rspec spec/pg
unset BOOTPAY_AUTH_MODE

# (4) 영구 전환 — .env 의 BOOTPAY_AUTH_MODE 값을 legacy 로 바꾸면 셸 export 없이도 동작
```

### 진입 헬퍼 — 어디서 토글이 흡수되는가

`spec/spec_helper.rb` 의 `create_pg_api` 가 `BOOTPAY_AUTH_MODE` 값에 따라 `create_pg_api_ck` 또는 `create_pg_legacy_api` 를 호출한다. 모든 PG spec 은 한 줄로 두 모드를 모두 지원한다:

```ruby
api = create_pg_api
```

ck/sk 모드는 토큰 발급이 불필요하고, legacy 모드는 spec 내부에서 `api.get_access_token` 을 호출해야 한다 — `legacy_compatibility_spec.rb` 참고.

### 실행 시 인증 모드 표시

`create_pg_api` 호출 시마다 stdout 에 한 줄로 어떤 모드가 활성화됐는지 표시된다 (`bundle exec rspec --format documentation` 또는 RSpec stdout 캡처가 꺼진 환경에서 즉시 확인):

```
[BOOTPAY_AUTH_MODE=new] PG: client_key/secret_key (Basic Auth) | env=production
[BOOTPAY_AUTH_MODE=legacy] PG: application_id/private_key (Bearer) | env=production
```

### 토글의 영향을 받지 않는 파일

다음 spec 은 두 모드를 한 example 안에서 모두 검증하므로 환경변수에 무관하게 동일한 동작을 한다:

- `spec/pg/token_spec.rb`
- `spec/pg/legacy_compatibility_spec.rb`

## 환경 전환

기본은 `production`. `.env` 또는 셸 환경변수로 `BOOTPAY_ENV=development` 를 설정하면 development 키 + dev 엔드포인트로 동작한다.

```bash
BOOTPAY_ENV=development bundle exec rspec spec/pg/payment_spec.rb
```

## 주의사항

1. **실제 API 호출**: 통합 테스트는 실제 Bootpay 서버에 요청을 보낸다 (production 기본).
2. **순서 의존성**: 일부 spec 은 다른 spec 결과(receipt_id, billing_key 등)를 필요로 한다.
3. **토큰 발급 비용**: legacy 모드는 매 spec 마다 `get_access_token` 을 호출한다. ck/sk 모드는 매 요청 Basic Auth 로 처리되어 별도 토큰 호출이 없다.
