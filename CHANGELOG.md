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