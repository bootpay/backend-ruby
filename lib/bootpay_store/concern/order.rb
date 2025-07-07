module BootpayStore::Concern::Order
  extend ActiveSupport::Concern

  included do
    # 주문 목록을 조회한다
    # Comment by GOSOMI
    # @date: 2025-06-19
    def orders(status: [], payment_status: [], keyword: nil, page: 1, cs_type: nil, search_date_from: nil, search_date_to: nil,
               user_id: nil, user_group_id: nil, idempotency_key: nil)
      request(
        uri:     'orders',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:
                 {
                   status:           status.join(','),
                   payment_status:   payment_status.join(','),
                   keyword:          keyword,
                   cs_type:          cs_type,
                   search_date_from: search_date_from,
                   search_date_to:   search_date_to,
                   page:             page,
                   user_id:          user_id,
                   user_group_id:    user_group_id
                 }.compact
      )
    end

    # 주문 상세를 조회한다
    def order_detail(order_id:, idempotency_key: nil)
      request(
        uri:     "orders/#{order_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end
  end
end