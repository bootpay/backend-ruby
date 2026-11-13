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
    # @date: 26-08-26 order_subscription_ids·subscription_billing_type 인자 추가.
    #   둘 다 서버(#index)가 읽고 있었는데 SDK 에 인자가 없어 구독 계약별·결제유형별 필터를 못 걸었다.
    #   order_subscription_ids 는 서버가 콤마 문자열과 배열을 모두 받으므로 status 와 같이 콤마로 join 한다.
    #   같은 날, 값이 비었을 때 status=&payment_status= 를 실어 보내던 것도 정리했다(서버는 무시했지만 노이즈).
    def orders(status: [], payment_status: [], keyword: nil, page: 1, limit: 20, cs_type: nil,
               search_date_from: nil, search_date_to: nil,
               user_id: nil, user_group_id: nil, order_subscription_ids: [],
               subscription_billing_type: nil, idempotency_key: nil)
      request(
        uri:     'orders',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:
                 {
                   status:                    Array(status).join(',').presence,
                   payment_status:            Array(payment_status).join(',').presence,
                   keyword:                   keyword,
                   cs_type:                   cs_type,
                   search_date_from:          search_date_from,
                   search_date_to:            search_date_to,
                   page:                      page,
                   limit:                     limit,
                   user_id:                   user_id,
                   user_group_id:             user_group_id,
                   order_subscription_ids:    Array(order_subscription_ids).join(',').presence,
                   subscription_billing_type: subscription_billing_type
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

    # 월별 주문 (GET /v1/orders/month)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    def order_month(user_group_id: nil, search_date: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'orders/month',
        method:  :get,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        params:  {
                   user_group_id: user_group_id,
                   search_date:   search_date
                 }.compact
      )
    end

    # 주문 발주 목록 (GET /v1/orders/:order_number/purchases)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # 회원을 지정하면 서버는 해당 회원의 주문만 연다
    def order_purchases(order_number:, user_id: nil, login_id: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     "orders/#{order_number}/purchases",
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

    # 주문 발주 수정 (PUT /v1/orders/:order_number/purchases)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # purchases: [{ order_purchase_number:, status:, chosen_product_option_id:, delivery_type:,
    #               delivery_company_code:, tracking_number: }, ...]
    def order_purchases_update(order_number:, purchases:, idempotency_key: nil)
      request(
        uri:     "orders/#{order_number}/purchases",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: { purchases: purchases }
      )
    end
  end
end
