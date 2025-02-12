module Bootpay::Concern::Wallet
  extend ActiveSupport::Concern

  included do
    # 설정된 wallet 기준으로 결제를 진행한다
    def request_wallet_payment(user_id:, order_name:, price:, tax_free: 0, webhook_url: nil, content_type: nil, order_id:,
                                  items: [], user: {}, extra: {}, metadata: {}, sandbox: false)
      request(
        uri:     'wallet/payment',
        payload: {
          user_id:      user_id,
          order_name:   order_name,
          price:        price,
          tax_free:     tax_free,
          webhook_url:  webhook_url,
          content_type: content_type,
          order_id:     order_id,
          items:        items,
          user:         user,
          extra:        extra,
          metadata:     metadata,
          sandbox:      sandbox
        }
      )
    end
  end
end