### 3.0.0

2025-03 부터 alpha.1~alpha.4 로 쌓아 온 3.0 라인을 **정식 릴리스**한다.
`gem install bootpay-backend-ruby` 로 바로 설치된다 (2.0.5 → 3.0.0).

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