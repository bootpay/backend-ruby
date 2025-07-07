module BootpayStore::Concern::OrderSubscription
  extend ActiveSupport::Concern
  included do
    # 계약된 구독정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-06-20
    def order_subscriptions(page: 1, keyword: nil, search_date_from: nil, search_date_to: nil,
                            request_type: nil, user_group_id: nil, status: nil, user_id: nil, idempotency_key: nil)
      request(
        uri:     'order_subscriptions',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  {
                   page:             page,
                   keyword:          keyword,
                   search_date_from: search_date_from,
                   search_date_to:   search_date_to,
                   request_type:     request_type,
                   user_group_id:    user_group_id,
                   status:           status,
                   user_id:          user_id
                 }.compact
      )
    end

    # 구독 상세를 조회한다
    def order_subscription_detail(order_subscription_id:, idempotency_key: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end
  end
end