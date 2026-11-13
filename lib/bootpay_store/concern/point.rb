module BootpayStore::Concern::Point
  extend ActiveSupport::Concern

  included do
    # 포인트 잔액 (GET /v1/point/balance)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # 회원 필수: user_id·login_id·user_jwt 중 하나
    def point_balance(user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'point/balance',
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   user_id:  user_id,
                   login_id: login_id
                 }.compact
      )
    end

    # 포인트 내역 (GET /v1/point/transactions)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # 회원 필수: user_id·login_id·user_jwt 중 하나
    def point_transactions(page: 1, limit: 20, transaction_type: nil, user_id: nil, login_id: nil, user_jwt: nil,
                           idempotency_key: nil)
      request(
        uri:     'point/transactions',
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   page:             page,
                   limit:            limit,
                   transaction_type: transaction_type,
                   user_id:          user_id,
                   login_id:         login_id
                 }.compact
      )
    end
  end
end
