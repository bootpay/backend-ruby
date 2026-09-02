### 3.0.0-alpha.4
- 알림톡 v1 API 35종 추가 — 발송·발송내역·공식 카탈로그·자체 템플릿·발신프로필·수신거부·알림톡 웹훅 7개 모듈
  - 알림톡 요청은 `Idempotency-Key` 를 싣지 않는다 (멱등은 발송의 `ref_id` 로만 성립)
  - `Bootpay-Role` 은 항상 `user` (스코프 키가 전부 `user:alimtalk_*`)
  - ⚠️ 샌드박스가 없다 — 발송·OTP·발신프로필 등록·템플릿 등록/검수는 실제로 나가고 과금된다
- 별건 현금영수증의 `pg` 를 선택 파라미터로 (미지정 시 가맹점 기본 PG 로 발행)
- mall_setting · order_subscription · supervisor · user · user_group · product · invoice ·
  payment · order · store · webhook · storage 모듈 확충
- alpha.3(2025-03-27) 이후 63커밋 누적분을 릴리스한다

### 3.0.0
- store api 추가
- 내부용 storage api 추가

### 2.0.5
- 빌링결제 api 추가 
- 계좌 빌링 결제 api 추가 

### 2.0.1
- readme update and republish

### 2.0.0 
- v1 -> v2 update 