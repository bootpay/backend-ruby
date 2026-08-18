module BootpayStore::Concern::Order
  extend ActiveSupport::Concern

  included do
    # 주문 목록을 조회한다
    # Comment by GOSOMI
    # @date: 2025-06-19
    # @date: 26-08-14 limit 인자 추가.
    #   서버가 limit 을 20 으로 하드코딩하고 있었는데 params[:limit] 수용(기본 20 · 최대 50)으로 바뀌었다.
    #   50 초과를 보내도 서버가 50 으로 클램프한다.
    #   ⚠️ 날짜 키는 search_date_from/to. 서버는 css_at/cse_at 도 별칭으로 받지만 SDK 는 정식 키만 쓴다.
    def orders(status: [], payment_status: [], keyword: nil, page: 1, limit: 20, cs_type: nil,
               search_date_from: nil, search_date_to: nil,
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
                   limit:            limit,
                   user_id:          user_id,
                   user_group_id:    user_group_id
                 }.compact
      )
    end

    # 주문 상세를 조회한다
    def order_detail(order_number:, idempotency_key: nil)
      request(
        uri:     "orders/#{order_number}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 주문 결제 승인
    # Comment by GOSOMI
    # @date: 2025-10-28
    def order_confirm(order_number:, idempotency_key: nil)
      request(
        uri:     'order/confirm',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: {
          order_number: order_number
        }
      )
    end
  end
end