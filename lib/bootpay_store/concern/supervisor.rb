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



    # 구독 단건 관리자 승인
    # 관리자 승인일 경우 bill 생성 후 (선불이면) 결제를 진행해야함
    # Comment by ehowlsla
    # @date: 2025-11-19
    def supervisor_request_order_subscription_approve(idempotency_key: nil, order_subscription_id:, approval_status:, reason: nil)
      request(
        uri:     "order_subscriptions/approve",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
          {
            order_subscription_id:    order_subscription_id,
            approval_status:          approval_status,
            reason:                   reason
          }.compact
      )
    end


    # 구독 단건 승인 거절
    # 요청된 구독건에 대해 거절 처리
    # 만약 생성된 bill 이 있다면 함께 취소 처리
    # Comment by ehowlsla
    # @date: 2025-11-9
    def supervisor_request_order_subscription_reject(idempotency_key: nil, order_subscription_id:, approval_status:, reason: nil)
      request(
        uri:     "order_subscriptions/reject",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'supervisor'
        },
        payload:
                 {
                   order_subscription_id:    order_subscription_id,
                   approval_status:          approval_status,
                   reason:                   reason
                 }.compact
      )
    end

  end
end