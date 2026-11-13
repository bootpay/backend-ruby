### Unreleased

- 커머스 쿠폰 API 3종 추가 — `coupon_list` · `coupon_available` · `coupon_download` (`/v1/coupon`).
- 커머스 적립금 API 2종 추가 — `point_balance` · `point_transactions` (`/v1/point`).
- 장바구니 주문 미리보기 추가 — `cart_order_preview` (`POST /v1/cart/order-preview`).
- 카테고리 API 5종 추가 — `category_list` · `category_detail` · `category_create` · `category_update` ·
  `category_delete` (`/v1/categories`). 등록·수정·삭제는 `Bootpay-Role: supervisor`.
- 정기구독 청구서 상세·수정 추가 — `order_subscription_bill_detail` · `order_subscription_bill_update`
  (`/v1/order_subscription_bills/:id`). 수정은 supervisor 전용이며 본문에도 `order_subscription_bill_id` 를 넣는다.
- 주문 월별 집계·발주 조회·발주 수정 추가 — `order_month` (`GET /v1/orders/month`) ·
  `order_purchases` · `order_purchases_update` (`/v1/orders/:order_number/purchases`).
- 가입 이메일 인증 대기 상태 조회 추가 — `user_authenticate` (`GET /v1/users/authenticate/:user_standby_id`,
  `verification_context` 선택).
- 회원 지정 계열 메서드는 `user_id` / `login_id` / `user_jwt`(`Bootpay-User-JWT`) 를 받으며,
  `idempotency_key` 를 안 주면 UUID 를 생성한다. nil 인자는 본문·쿼리에서 뺀다.

### 3.2.0

- 뱅크알람 입금대기 API 5종 추가 — `deposit_accounts` · `deposit_webhook_secret` · `deposit_create` ·
  `deposit_detail` · `deposit_cancel` (`/v1/sdk/deposits`). 가맹점 서버가 입금 전 주문을 등록하면 판매자 폰의
  입금 알림 중 금액·입금자명이 맞는 것을 뱅크알람이 연결해 입금 웹훅으로 알린다.
  같은 `merchant_order_id` 로 금액·입금자명·계좌가 같은 재호출은 기존 주문을 돌려주고, 하나라도 다르면 `18110`.
  `deposit_webhook_secret` 은 부를 때마다 비밀값이 바뀌고 원문은 그 응답에서만 온다.
  `deposit_id` 는 가맹점 주문번호 또는 부트페이 주문번호이며 경로 인코딩한다. 웹훅 이벤트 상수
  `BootpayStore::Concern::Deposit::BANK_DEPOSIT_WEBHOOK_EVENT_*`(400~407).
- 입점사 지급 요청 API 3종 추가 — `payout_create` · `payout_detail` · `payouts` (`/v1/sdk/payouts`).
  가맹점 지정 금액(`manual`) 정산 쇼핑몰이 입점사·지급액을 정해 지급 원장에 등록하고, 송금은 부트페이 배치가 한다.
  같은 `merchant_payout_id` 재호출은 처음 항목을 돌려준다. `payouts` 의 응답 `data` 는 항목 배열이다(전체 개수 없음).
- 위 8개는 전부 supervisor scope 라 `Bootpay-Role: supervisor` 로 보내며, `idempotency_key` 를 안 주면 UUID 를 생성한다.
  nil 인자는 본문·쿼리에서 뺀다(`deposit_create` 의 `notify` 안쪽 포함, `false` 는 유지).
- `product_create` · `product_update` · `product_delete` · `product_status` 의 `Bootpay-Role` 을 `manager` → `user` 로.
  서버 스코프가 `user:product_*` 뿐이라 manager 로 보내면 401 `API_ROLE_NOT_SUPPORT(-50)` 였다.
- `alimtalk_webhook_update` 에 `retry_count` 인자 추가(선택). 웹훅 전달 실패 시 건별 재시도 횟수를
  `1`~`25` 사이로 정한다(기본 `10`). 범위 밖 값을 주면 `11304` 로 거부된다. 생략하면 기존에 저장된
  값을 그대로 유지하므로 기존 호출은 변화 없이 동작한다.

### 3.1.0

- 커머스 게시판 API 28종 SDK 메서드 추가 — FAQ · 공지사항 · 1:1 문의 · 상품문의(Q&A) · 상품평.
  `BootpayStore::RestClient` 에 아래 메서드가 생긴다.
  - FAQ(5): `faqs` `faq_detail` `faq_create` `faq_update` `faq_delete`
  - 공지사항(5): `notices` `notice_detail` `notice_create` `notice_update` `notice_delete`
  - 1:1 문의(6): `inquiries` `inquiry_detail` `inquiry_create` `inquiry_update` `inquiry_delete` `inquiry_answer`
  - 상품문의(6): `product_qnas` `product_qna_detail` `product_qna_create` `product_qna_update` `product_qna_delete` `product_qna_answer`
  - 상품평(6): `reviews` `review_detail` `review_create` `review_update` `review_delete` `review_reply`
  공통 규칙: 목록·단건·삭제 조회 계열은 `supervisor: true` 를 주면 운영자 모드(`Bootpay-Role: supervisor`)로
  비공개·숨김 글까지 다루고, 기본값은 고객 모드다. 등록·수정 계열 중 `faq_*` · `notice_*` 와
  `*_answer` / `review_reply` 는 운영자 전용이다. 회원 대상 메서드는 `user_id` · `login_id` · `user_jwt`
  중 하나로 회원을 지정하며, `product_qna_create` 는 몰이 허용할 때 `guest_name` + `guest_password` 로
  비회원 작성도 된다. 모든 메서드가 `idempotency_key` 를 받고 안 주면 UUID 를 자동 생성한다.
  기존 상품 상세의 공개 상품평 목록(`GET /v1/products/:id/reviews`)은 그대로 쓴다.
- `alimtalk_send` / `alimtalk_send_bulk` 에 `webhook_url` 인자 추가(선택). 주면 그 건(bulk 는 요청 전체)의
  발송 성공·실패·문자 대체발송·예약취소 웹훅이 **이 주소로만** 가고 프로젝트 웹훅 설정은 쓰이지 않는다.
  `https` 만 허용하며 2,000자를 넘으면 `3028` 로 거부된다(bulk 는 요청 전체가 거부). 서명은 프로젝트
  시크릿으로 하며, 시크릿만 필요하면 `alimtalk_webhook_rotate_secret` 으로 설정 없이 발급받을 수 있다.
  ⚠️ 같은 `ref_id` 로 이미 접수·성공한 건을 다시 요청하면 기존 접수가 그대로 돌아와 새 주소는 무시된다.
  기본값이 `nil` 이라 기존 호출은 그대로 동작한다.
- 알림톡 API(`alimtalk_*` 메서드 35종) 요청 호스트 변경 — `/alimtalk/*` 경로는 커머스 API(`api.bootapi.com/v1`)가
  아니라 메시지 API(`message.bootapi.com`, 경로에 `/v1` 없음)로 보낸다. development 는 `dev-m.bootapi.com`,
  stage 는 `stage-m.bootapi.com`. 경로·파라미터·응답은 그대로이며 메서드 시그니처 변경 없음.
  옛 주소(`api.bootapi.com/v1/alimtalk/*`)는 410 으로 응답한다.
- `BootpayStore::RestClient::MESSAGE_API` 상수와 `set_message_api_url(url)` 추가 — 알림톡 호스트만 따로 바꿀 수 있다.
  그 외 API 는 기존처럼 `API` / `set_api_url` 을 쓴다.

### 3.0.1

`bootpay` 이름으로 낸 3.0.0 을 실제 배포본으로 점검하다 나온 수정 2건. **API 변경 없음.**

- `basic_or_request_access_token` 이 항상 `Bootpay::Response` 를 돌려준다.
  client_key/secret_key 를 쓰면 Basic Auth 라 토큰 요청이 필요 없는데, 그 분기에서
  `success?` 만 정의된 **맨 `Object`** 를 돌려주고 있었다. 다른 메서드처럼 `.data` 를 부르면
  `NoMethodError` 로 죽는다. `success?` 동작은 그대로다(둘 다 true).
- gemspec 의 `required_ruby_version` 제거. 3.0.0 에서 `>= 2.6.0` 으로 선언했는데 **근거 없는
  추정값**이었다 — 실제 의존성 체인은 그보다 높은 Ruby 를 요구한다. 정확한 하한을 확인하기 전까지
  잘못된 값을 박아 두는 대신 선언하지 않는다(3.0.0 이전과 같은 상태).
- Gemfile 주석의 옛 gemspec 파일명 정정.

검증(development, 읽기 전용): PG 토큰·Commerce 토큰·상품 조회·알림톡 수신거부/발신프로필 조회가
모두 도메인 응답으로 성공. 알림톡 메서드 35개 로드 확인.

### 3.0.0

2025-03 부터 alpha.1~alpha.4 로 쌓아 온 3.0 라인을 **정식 릴리스**한다.

#### ⚠️ gem 이름이 `bootpay` 로 바뀐다

이 버전부터 **정본 gem 은 `bootpay`** 다. 같은 코드가 `bootpay-backend-ruby` 3.0.0 으로도
배포돼 있지만, **앞으로 신규 릴리스는 `bootpay` 로만 나간다.**

```ruby
# Gemfile
gem 'bootpay', '~> 3.0'
```
```bash
$ gem install bootpay
```

- **`bootpay-backend-ruby` 사용자**: `require 'bootpay-backend-ruby'` 는 계속 동작한다
  (호환 진입점을 남겨 두었다). Gemfile 만 `gem 'bootpay'` 로 바꾸면 코드 변경은 없다.
  기존 `bootpay-backend-ruby` 버전들은 RubyGems 에 그대로 남지만 갱신되지 않는다.
- **`bootpay` 1.x 사용자**: ⚠️ 1.x 와 3.0.0 은 **계보가 다르다.** 진입 클래스부터 바뀐다
  (`Bootpay::Api` → `Bootpay::RestClient`). 1.x 를 계속 쓰려면 `gem 'bootpay', '~> 1.2'`
  로 버전을 고정하면 된다. 두 계보는 파일 경로가 겹치지 않는다.
- `Bootpay::VERSION` 이 정본 상수다. `Bootpay::V2_VERSION` 은 같은 값을 가리키는 별칭으로 남는다.

#### 추가
- **알림톡 v1 API 35종** — 발송·발송내역·공식 카탈로그·자체 템플릿·발신프로필·수신거부·알림톡 웹훅 7개 모듈
  - 알림톡 요청은 `Idempotency-Key` 를 싣지 않는다 (멱등은 발송의 `ref_id` 로만 성립)
  - `Bootpay-Role` 은 항상 `user` (스코프 키가 전부 `user:alimtalk_*`)
  - ⚠️ **샌드박스가 없다** — 발송·OTP·발신프로필 등록·템플릿 등록/검수는 실제로 나가고 과금된다
  - ⚠️ 템플릿 버튼은 **등록 API 와 발송 API 의 키 이름이 다르다**.
    등록은 `linkType`·`linkMo`·`linkPc`·`linkIos`·`linkAnd` 를 쓴다
    (발송 포맷 `type`·`url_mobile` 로 보내면 서버가 거부한다)
- Commerce store 모듈 — mall_setting · order · order_subscription · supervisor · user ·
  user_group · product · invoice · payment · webhook
- 내부용 storage 모듈

#### 변경
- 별건 현금영수증의 `pg` 를 **선택 파라미터**로 (미지정 시 가맹점에 설정된 기본 PG 로 발행).
  종전에는 필수라 기본 PG 를 쓰려는 가맹점도 PG명을 적어 넣어야 했다.

#### 배포 산출물
- gemspec 이 루트의 `tests_*.rb` · `*.gem` · `.env*` 도 제외한다.
  종전 규칙은 `test/`·`spec/`·`features/` **디렉터리**만 걸러서, 루트의
  `tests_basic_auth_product_info.rb` 가 dev Commerce 키를 하드코딩한 채 gem 에 실려 나갔다.
- 해당 스크립트는 `BP_CLIENT_KEY`/`BP_SECRET_KEY` 환경변수 전용으로 바뀌었다.

#### 알려진 사항
- spec 스위트는 dev 서버 라이브 호출 기반이라 오프라인 회귀 게이트가 아니다.

### 3.0.0-alpha.4
- 알림톡 v1 API 35종 추가 — 발송·발송내역·공식 카탈로그·자체 템플릿·발신프로필·수신거부·알림톡 웹훅 7개 모듈
  - 알림톡 요청은 `Idempotency-Key` 를 싣지 않는다 (멱등은 발송의 `ref_id` 로만 성립)
  - `Bootpay-Role` 은 항상 `user` (스코프 키가 전부 `user:alimtalk_*`)
  - ⚠️ 샌드박스가 없다 — 발송·OTP·발신프로필 등록·템플릿 등록/검수는 실제로 나가고 과금된다
- 별건 현금영수증의 `pg` 를 선택 파라미터로 (미지정 시 가맹점 기본 PG 로 발행)
- mall_setting · order_subscription · supervisor · user · user_group · product · invoice ·
  payment · order · store · webhook · storage 모듈 확충
- alpha.3(2025-03-27) 이후 63커밋 누적분을 릴리스한다

### 3.0.0-alpha.1
- store api 추가
- 내부용 storage api 추가

### 2.0.5
- 빌링결제 api 추가 
- 계좌 빌링 결제 api 추가 

### 2.0.1
- readme update and republish

### 2.0.0 
- v1 -> v2 update 