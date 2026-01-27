module BootpayStore::Concern::Supervisor
  extend ActiveSupport::Concern

  included do
    # 주문 취소
    # Comment by GOSOMI
    # @date: 2025-04-04
    def supervisor_request_order_cancel(idempotency_key: nil, cancel_id: nil, order_number:, cancel_products: nil, cancel_price: nil,
                                        cancel_tax_free_price: 0, cancel_requester: '시스템', cancel_message: '요청취소', cancel_immediately: false,
                                        cancel_order_subscription_bills: nil)
      request(
        uri:     'order/cancel',
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
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

    # bill 주문 취소
    # 전체취소 하거나, 부분취소할 수 있다.
    # 부분취소는 상품으로하거나 금액으로 할 수 있는데, 상품으로 취소되면 배송비 등이 자동 계산되지만, 금액으로 취소는 환불개념이라 자동계산 되지 않는다.
    # Comment by ehowlsla
    # @date: 2025-04-04
    def supervisor_request_order_subscription_bill_cancel(idempotency_key: nil, cancel_id: nil, order_subscription_bill_id:, cancel_products: [], cancel_price: nil,
                                                          cancel_tax_free_price: nil, cancel_requester: '시스템', cancel_message: '요청취소', cancel_immediately: false)

      request(
        uri:     'order_subscriptions/bill/cancel',
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
                 {
                   order_subscription_bill_id: order_subscription_bill_id,
                   cancel_id:                  cancel_id,
                   cancel_products:            cancel_products,
                   cancel_price:               cancel_price,
                   cancel_tax_free_price:      cancel_tax_free_price,
                   cancel_requester:           cancel_requester,
                   cancel_message:             cancel_message,
                   cancel_immediately:         cancel_immediately
                 }.compact
      )

    end

    # 구독 단건 관리자 승인
    # 관리자 승인일 경우 bill 생성 후 (선불이면) 결제를 진행해야함
    # Comment by ehowlsla
    # @date: 2025-11-19
    def supervisor_request_order_subscription_approve(idempotency_key: nil, order_subscription_id:, reason: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/approve",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
                 {
                   reason: reason
                 }.compact
      )
    end

    # 구독 단건 승인 거절
    # 요청된 구독건에 대해 거절 처리
    # 만약 생성된 bill 이 있다면 함께 취소 처리
    # Comment by ehowlsla
    # @date: 2025-11-9
    def supervisor_request_order_subscription_reject(idempotency_key: nil, order_subscription_id:, reason: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/reject",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
                 {
                   reason: reason
                 }.compact
      )
    end

    # 구독 해지 실행
    # Comment by GOSOMI
    # @date: 2026-01-21
    def supervisor_request_order_subscription_terminate(idempotency_key: nil, order_subscription_id:, reason: nil,
                                                        termination_fee: nil, last_bill_refund_price: nil, final_fee: nil,
                                                        service_end_at: nil, cancel_date: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/terminate",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
                 {
                   reason:                 reason,
                   termination_fee:        termination_fee,
                   last_bill_refund_price: last_bill_refund_price,
                   final_fee:              final_fee,
                   service_end_at:         service_end_at,
                   cancel_date:            cancel_date
                 }.compact
      )
    end

    # 구독 멈춤
    # Comment by GOSOMI
    # @date: 2026-01-22
    def supervisor_request_order_subscription_pause(idempotency_key: nil, order_subscription_id:, reason: nil,
                                                    paused_at:, expected_resume_at: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/pause",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
                 {
                   reason:             reason,
                   paused_at:          paused_at,
                   expected_resume_at: expected_resume_at
                 }.compact
      )
    end

    # 구독 재개
    # Comment by GOSOMI
    # @date: 2026-01-22
    def supervisor_request_order_subscription_resume(idempotency_key: nil, order_subscription_id:, reason: nil)
      request(
        uri:     "order_subscriptions/#{order_subscription_id}/resume",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
                 {
                   reason: reason
                 }.compact
      )
    end
  end
end