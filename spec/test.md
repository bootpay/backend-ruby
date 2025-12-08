# Ruby SDK 테스트 실행 가이드

## 환경 설정

`spec/spec_helper.rb` 파일에서 환경을 설정합니다:

```ruby
# 'development' 또는 'production'으로 설정
CURRENT_ENV = 'production'
```

## 테스트 실행

### 전체 테스트 실행
```bash
cd /Users/taesupyoon/bootpay/server/sdk/ruby
bundle exec rspec spec/bootpay/pg/
```

### 개별 테스트 실행
```bash
# 토큰 발급
bundle exec rspec spec/bootpay/pg/request_token_spec.rb

# 결제 조회
bundle exec rspec spec/bootpay/pg/receipt_payment_spec.rb

# 결제 승인
bundle exec rspec spec/bootpay/pg/confirm_payment_spec.rb

# 결제 취소
bundle exec rspec spec/bootpay/pg/cancel_spec.rb

# 본인인증 조회
bundle exec rspec spec/bootpay/pg/certificate_spec.rb

# 빌링키 조회
bundle exec rspec spec/bootpay/pg/billing_key_spec.rb

# 빌링키 삭제
bundle exec rspec spec/bootpay/pg/destroy_billing_key_spec.rb

# 정기결제 실행
bundle exec rspec spec/bootpay/pg/subscribe_card_payment_spec.rb

# 예약 결제
bundle exec rspec spec/bootpay/pg/subscribe_payment_reserve_spec.rb

# 예약 결제 취소
bundle exec rspec spec/bootpay/pg/cancel_subscribe_reserve_spec.rb

# 결제건 현금영수증 발행
bundle exec rspec spec/bootpay/pg/cash_publish_on_receipt_spec.rb

# 결제건 현금영수증 취소
bundle exec rspec spec/bootpay/pg/cash_cancel_on_receipt_spec.rb

# 현금영수증 발행
bundle exec rspec spec/bootpay/pg/request_cash_receipt_spec.rb

# 현금영수증 취소
bundle exec rspec spec/bootpay/pg/cancel_cash_receipt_spec.rb

# 에스크로 배송시작
bundle exec rspec spec/bootpay/pg/shipping_start_spec.rb

# 사용자 토큰 발급
bundle exec rspec spec/bootpay/pg/request_user_token_spec.rb
```

## 테스트 데이터

`spec/spec_helper.rb`에서 `TEST_DATA` 상수를 통해 테스트 데이터를 관리합니다:

```ruby
TEST_DATA = {
  receipt_id: '628b2206d01c7e00209b6087',
  receipt_id_confirm: '62876963d01c7e00209b6028',
  receipt_id_cash: '62e0f11f1fc192036b1b3c92',
  receipt_id_escrow: '628ae7ffd01c7e001e9b6066',
  receipt_id_billing: '62c7ccebcf9f6d001b3adcd4',
  receipt_id_transfer: '66541bc4ca4517e69343e24c',
  billing_key: '628b2644d01c7e00209b6092',
  billing_key_2: '66542dfb4d18d5fc7b43e1b6',
  reserve_id: '6490149ca575b40024f0b70d',
  reserve_id_2: '628b316cd01c7e00219b6081',
  user_id: '1234',
  certificate_receipt_id: '61b009aaec81b4057e7f6ecd'
}
```

## 폴더 구조

```
spec/
├── spec_helper.rb      # 설정 및 헬퍼 함수
├── test.md             # 테스트 가이드
└── bootpay/
    ├── pg/             # PG API 테스트
    │   ├── request_token_spec.rb
    │   ├── receipt_payment_spec.rb
    │   ├── confirm_payment_spec.rb
    │   └── ...
    ├── authenticate/   # 인증 관련 테스트
    └── rest/           # REST 관련 테스트
```
