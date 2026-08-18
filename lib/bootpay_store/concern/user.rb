module BootpayStore::Concern::User
  extend ActiveSupport::Concern

  included do
    # 회원 로그인 (V1 API)
    # Comment by Codex
    # @date: 2026-02-23
    # @date: 26-08-14 uri 'user/login' → 'users/session' 로 정정.
    #   v1 에는 단수 user/* 라우트가 없다(bin/rails routes 844줄 전수 확인). 로그인은 POST /v1/users/session (v1/users/sessions#create).
    #   /mall/user/login 은 스토어프론트 스코프라 서버사이드 SDK(base=/v1)와 무관하다.
    def user_login(login_id:, password:, corporate_type: 0, idempotency_key: nil)
      request(
        uri:     'users/session',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
        },
        payload: {
                   login_id:       login_id,
                   password:       password,
                   corporate_type: corporate_type
                 }.compact
      )
    end

    # 회원 세션 조회 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
    # @date: 26-08-14 uri 'user/session' → 'users/session' 로 정정 (GET /v1/users/session).
    def user_session(user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'users/session',
        method:  :get,
        headers: {
                   'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
                   'Bootpay-User-JWT' => user_jwt
                 }.compact
      )
    end

    # 회원 로그아웃 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
    # @date: 26-08-14 uri 'user/session' → 'users/session' 로 정정 (DELETE /v1/users/session).
    def user_logout(user_jwt:, idempotency_key: nil)
      request(
        uri:     'users/session',
        method:  :delete,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-User-JWT' => user_jwt
        }
      )
    end

    # 회원가입 (V1 API) — 일반 회원가입용
    # Comment by Codex
    # @date: 2026-02-23
    # @date: 26-08-14 uri 'user/join' → 'users/join' 로 정정 (POST /v1/users/join).
    #   ⚠️ external_user_sign_in 과 같은 엔드포인트를 부른다. 중복이 아니라 용도가 다르다 —
    #   이쪽은 password/corporate_type/group 을 쓰는 일반 회원가입, 저쪽은 uid/login_email/login_pw 를 쓰는 외부 uid 연동 가입이다.
    #   서버가 파라미터 조합으로 분기하므로 둘 다 유지한다(26-08-14 사용자 결정). 매뉴얼 customer/register.md 는 external_user_sign_in 에 대응.
    def user_join(login_id:, password:, name:, email: nil, phone: nil, nickname: nil, gender: nil, birth: nil, corporate_type: 0,
                  group: nil, idempotency_key: nil)
      request(
        uri:     'users/join',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
        },
        payload: {
                   login_id:       login_id,
                   password:       password,
                   name:           name,
                   email:          email,
                   phone:          phone,
                   nickname:       nickname,
                   gender:         gender,
                   birth:          birth,
                   corporate_type: corporate_type,
                   group:          group
                 }.compact
      )
    end

    # 회원가입 중복 확인 (V1 API) — key 를 인자로 받는 일반형
    # type: email-exist, id-exist, phone-exist, uid-exist, group-business-number-exist
    # Comment by Codex
    # @date: 2026-02-23
    # @date: 26-08-14 uri 'user/join/#{type}' → 'users/join/#{type}' 로 정정 (GET /v1/users/join/:id).
    #   ⚠️ email_exist·id_exist·phone_exist·uid_exist·group_business_number_exist 전용형 5종과 기능이 겹치지만 둘 다 유지한다(26-08-14 사용자 결정).
    #   일반형은 서버에 새 key 가 생겨도 SDK 수정 없이 쓸 수 있고, 매뉴얼 customer/check-exist.md 가 key/value 형태를 안내하므로 이쪽에 대응한다.
    def user_join_check(type:, pk:, idempotency_key: nil)
      request(
        uri:     "users/join/#{type}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
        },
        params:  {
          pk: pk
        }
      )
    end

    # UserId로 로그인을 시도한다
    # Comment by GOSOMI
    # @date: 2025-04-25
    def login_by_user_id(user_id:, membership_type: 'member', corporate_type: 'individual', idempotency_key: nil)
      request(
        uri:     "users/login/token",
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   user_id:         user_id,
                   membership_type: membership_type,
                   corporate_type:  corporate_type
                 }
      )
    end

    # 회원 목록 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-06-16
    def users(member_type: nil, keyword: nil, page: 1, limit: 20, idempotency_key: nil)
      request(
        uri:     'users',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:
                 {
                   member_type: member_type,
                   keyword:     keyword,
                   page:        page,
                   limit:       limit
                 }.compact
      )
    end

    # 회원정보를 조회한다
    # Comment by GOSOMI
    # @date: 2025-06-16
    def lookup_user(user_id:, idempotency_key: nil)
      request(
        uri:     "users/#{user_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
        }
      )
    end

    # 회원가입
    # Comment by GOSOMI
    # @date: 2025-06-16
    def external_user_sign_in(idempotency_key: nil, uid:, user_group_id: nil, is_group_admin: false,
                              name:, phone:, email:, tel: nil, nickname: nil, comment: nil,
                              gender: nil, birth: nil, individual_extension: nil, login_id:, login_email:,
                              login_pw: nil, join_at: nil)
      request(
        uri:     'users/join',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   uid:                  uid,
                   user_group_id:        user_group_id,
                   is_group_admin:       is_group_admin,
                   name:                 name,
                   phone:                phone,
                   email:                email,
                   tel:                  tel,
                   nickname:             nickname,
                   comment:              comment,
                   gender:               gender,
                   birth:                birth,
                   individual_extension: individual_extension,
                   login_id:             login_id,
                   login_email:          login_email,
                   login_pw:             login_pw,
                   join_at:              join_at
                 }.compact
      )
    end

    # 회원 탈퇴
    # Comment by GOSOMI
    # @date: 2025-06-16
    def withdraw(user_id:, idempotency_key: nil)
      request(
        uri:     "users/#{user_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 이메일 중복검사
    # Comment by GOSOMI
    # @date: 2025-06-18
    def email_exist(email:, idempotency_key: nil)
      request(
        uri:     'users/join/email-exist',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  { pk: email }
      )
    end

    # ID 중복검사
    # Comment by GOSOMI
    # @date: 2025-06-18
    def id_exist(id:, idempotency_key: nil)
      request(
        uri:     'users/join/id-exist',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  { pk: id }
      )
    end

    # 전화번호 중복검사
    # Comment by GOSOMI
    # @date: 2025-06-18
    def phone_exist(phone:, idempotency_key: nil)
      request(
        uri:     'users/join/phone-exist',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  { pk: phone }
      )
    end

    # 그룹 사업자 번호 중복검사
    # Comment by GOSOMI
    # @date: 2025-06-18
    def group_business_number_exist(business_number:, idempotency: nil)
      request(
        uri:     'users/join/group-business-number-exist',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  { pk: business_number }
      )
    end

    # 외부 uid(ex_uid) 중복검사 (GET /v1/users/join/uid-exist)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # email/id/phone/group-business-number 전용형과 같은 패턴. 이걸로 *_exist 계열이 5종 완성된다.
    def uid_exist(uid:, idempotency_key: nil)
      request(
        uri:     'users/join/uid-exist',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  { pk: uid }
      )
    end

    # 회원 정보를 수정한다 (PUT /v1/users/:id)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # 컨트롤러 build_user_params 기준. 사업자 정보는 group: { company_name:, business_number:, registration_number: } 로 중첩 전달.
    # 바뀐 값만 보내면 된다.
    def user_update(user_id:, login_id: nil, login_pw: nil, name: nil, phone: nil, email: nil,
                    tel: nil, nickname: nil, bank_username: nil, bank_account: nil, bank_code: nil,
                    comment: nil, gender: nil, birth: nil, group: nil, idempotency_key: nil, **attrs)
      request(
        uri:     "users/#{user_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: {
                   login_id:      login_id,
                   login_pw:      login_pw,
                   name:          name,
                   phone:         phone,
                   email:         email,
                   tel:           tel,
                   nickname:      nickname,
                   bank_username: bank_username,
                   bank_account:  bank_account,
                   bank_code:     bank_code,
                   comment:       comment,
                   gender:        gender,
                   birth:         birth,
                   group:         group
                 }.merge(attrs).compact
      )
    end
  end
end
