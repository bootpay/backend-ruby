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
    def request_order_cancel_revoke(idempotency_key: nil, order_cancellation_request_id:)
      request(
        uri:     "order/cancel/#{order_cancellation_request_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid
        }
      )
    end
  end
end