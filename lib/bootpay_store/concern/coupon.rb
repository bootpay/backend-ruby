module BootpayStore::Concern::Coupon
  extend ActiveSupport::Concern

  included do
    # 쿠폰 목록 (GET /v1/coupon)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # 회원 필수: user_id·login_id·user_jwt 중 하나
    def coupon_list(status: nil, page: nil, limit: nil, user_id: nil, login_id: nil, user_jwt: nil,
                    idempotency_key: nil)
      request(
        uri:     'coupon',
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   status:   status,
                   page:     page,
                   limit:    limit,
                   user_id:  user_id,
                   login_id: login_id
                 }.compact
      )
    end

    # 사용 가능한 쿠폰 (GET /v1/coupon/available)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # 회원 필수: user_id·login_id·user_jwt 중 하나
    def coupon_available(user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'coupon/available',
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

    # 쿠폰 다운로드 (POST /v1/coupon/download)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # 회원 필수: user_id·login_id·user_jwt 중 하나 (POST 라 user_id·login_id 는 본문으로 보낸다)
    def coupon_download(coupon_template_id:, user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'coupon/download',
        method:  :post,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   coupon_template_id: coupon_template_id,
                   user_id:            user_id,
                   login_id:           login_id
                 }.compact
      )
    end
  end
end
