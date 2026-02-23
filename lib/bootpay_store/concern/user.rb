module BootpayStore::Concern::User
  extend ActiveSupport::Concern

  included do
    # 회원 로그인 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
    def user_login(login_id:, password:, corporate_type: 0, idempotency_key: nil)
      request(
        uri:     'user/login',
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
    def user_session(user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'user/session',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-User-JWT' => user_jwt
        }.compact
      )
    end

    # 회원 로그아웃 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
    def user_logout(user_jwt:, idempotency_key: nil)
      request(
        uri:     'user/session',
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-User-JWT' => user_jwt
        }
      )
    end

    # 회원가입 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
    def user_join(login_id:, password:, name:, email: nil, phone: nil, nickname: nil, gender: nil, birth: nil, corporate_type: 0,
                  group: nil, idempotency_key: nil)
      request(
        uri:     'user/join',
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

    # 회원가입 중복 확인 (V1 Mall API)
    # type: email-exist, id-exist, phone-exist, group-business-number-exist
    # Comment by Codex
    # @date: 2026-02-23
    def user_join_check(type:, pk:, idempotency_key: nil)
      request(
        uri:    "user/join/#{type}",
        method: :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
        },
        params: {
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
  end
end
