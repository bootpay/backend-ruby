### 1.2.0
- NodeJS @bootpay/backend-js@2.6.0 기준 PG API parity 보완. 신규 11개 메서드 추가 (기존 메서드 시그니처/URL 불변, 백워드 호환 유지).
  - 본인인증: `request_authentication`, `confirm_authentication`, `realarm_authentication`
  - 현금영수증: `cash_receipt_publish_on_receipt`, `cash_receipt_cancel_on_receipt`, `request_cash_receipt`, `cancel_cash_receipt`
  - 자동이체 빌링키: `request_subscribe_automatic_transfer_billing_key`, `publish_automatic_transfer_billing_key`
  - 단일 조회: `lookup_billing_key`, `subscribe_payment_reserve_lookup`
- `Bootpay::Rest#request` 에 `params:` 옵션 추가 — DELETE 의 query-string (현금영수증 취소의 `cancel_username` / `cancel_message`) 등에 사용. 기존 호출은 영향 없음.

### 1.0.6 
- request_link api 에 주석 추가 

### 1.0.5
- model별 주석 추가, extra에 불필요한 파라미터 제거

### 1.0.4

- cancel에 refund 형식 수정 

### 1.0.3 

- BankCode 추가

### 1.0.2
- certificate data type application/json 으로 수정

### 1.0.1
- namespace 변경  

### 1.0.0

- 첫 배포 
