module BootpayStore::Concern::Payment
  extend ActiveSupport::Concern

  included do
    # 주문 취소
    # Comment by GOSOMI
    # @date: 2025-04-04
    def request_order_cancel(idempotency_key: nil, cancel_id: nil, order_number:, cancel_products: nil, cancel_price: nil,
                             cancel_tax_free_price: 0, cancel_requester: '시스템', cancel_message: '요청취소', cancel_immediately: false,
                             cancel_order_subscription_bills: nil)
      request(
        uri:     'order/cancel',
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   order_number:              order_number,
                   request_cancel_parameters: {
                                                cancel_id:                       cancel_id,
                                                cancel_products:                 cancel_products,
                                                cancel_order_subscription_bills: cancel_order_subscription_bills,
                                                cancel_price:                    cancel_price,
                                                cancel_tax_free_price:           cancel_tax_free_price,
                                                cancel_requester:                cancel_requester,
                                                cancel_message:                  cancel_message,
                                                cancel_immediately:              cancel_immediately
                                              }.compact
                 }.compact
      )
    end

    # 주문 취소 요청을 철회한다
    # def request_order_cancel_revoke(idempotency_key: nil, order_cancellation_request_id:)
    #   request(
    #     uri:     "order/cancel/#{order_cancellation_request_id}",
    #     method:  :delete,
    #     headers: {
    #       'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
    #     }
    #   )
    # end

    # (관리자)
    # 주문 취소 요청을 반려처리 한다
    def reject_order_cancel(idempotency_key: nil, order_cancellation_request_id:, message: nil)
      request(
        uri:     "order/cancel/#{order_cancellation_request_id}/reject",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   message: message
                 }.compact
      )
    end

    # (관리자)
    # 주문 취소 요청을 승인처리 한다
    # @date: 26-08-14 인자명 통일 — 서버(v1/order/cancel_controller)는 approve/reject/withdraw 셋 다
    #   params[:id] 를 order_cancellation_request_id 로 동일하게 취급한다. reject 와 이름이 달라 다른 값처럼
    #   보였던 문제를 order_cancellation_request_id: 로 맞춘다. 구 이름도 계속 받는다(하위호환).
    def approve_order_cancel(idempotency_key: nil, order_cancellation_request_id: nil,
                             order_cancellation_request_history_id: nil, message: nil)
      cancellation_id = order_cancellation_request_id.presence || order_cancellation_request_history_id
      request(
        uri:     "order/cancel/#{cancellation_id}/approve",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload: {
                   message: message
                 }.compact
      )
    end

    # 주문 취소 요청 내역을 조회한다 (GET /v1/order/cancel)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # order_number 또는 order_id 로 필터. 둘 다 없으면 전체.
    # approve/reject/withdraw 에 넘길 :id 를 여기서 얻는다 — 이게 없어서 승인/반려가 사실상 쓸 수 없었다.
    def order_cancel_list(order_number: nil, order_id: nil, idempotency_key: nil)
      request(
        uri:     'order/cancel',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  {
                   order_number: order_number,
                   order_id:     order_id
                 }.compact
      )
    end

    # (구매자) 주문 취소 요청을 철회한다 (PUT /v1/order/cancel/:id/withdraw)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # ⚠️ 주석 처리된 request_order_cancel_revoke(DELETE order/cancel/:id) 와 다른 라우트다.
    #    서버에는 destroy(DELETE :id)와 withdraw(PUT :id/withdraw)가 둘 다 있고 같은 모델 메서드를 부른다.
    #    매뉴얼이 문서화한 쪽은 withdraw 이므로 이쪽을 쓴다.
    def order_cancel_withdraw(order_cancellation_request_id:, idempotency_key: nil)
      request(
        uri:     "order/cancel/#{order_cancellation_request_id}/withdraw",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end
  end
end