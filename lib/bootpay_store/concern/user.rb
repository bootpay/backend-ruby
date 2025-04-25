module BootpayStore::Concern::User
  extend ActiveSupport::Concern

  included do
    # UserId로 로그인을 시도한다
    # Comment by GOSOMI
    # @date: 2025-04-25
    def login_by_user_id(user_id:, idempotency_key: nil)
      request(
        uri:     "users/login/token",
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
        },
        payload:
                 {
                   user_id: user_id
                 }
      )
    end
  end
end