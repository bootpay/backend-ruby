module Bootpay::Concern::Webhook
  extend ActiveSupport::Concern

  included do
    # Access Token을 요청한다
    # Comment by Gosomi
    # Date: 2021-05-21
    def request_webhook(receipt_id:, webhook_url:)
      request(
        uri:     'request/webhook',
        payload: {
          receipt_id:  receipt_id,
          webhook_url: webhook_url
        }
      )
    end
  end
end