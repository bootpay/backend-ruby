module BootpayStore::Concern::Webhook
  extend ActiveSupport::Concern

  included do
    # 테스트 웹훅을 발송한다 (POST /v1/test-webhooks)
    # @comment_by Claude (alfred)
    # @date: 26-03-05
    def send_test_webhook(header_content_type: nil)
      request(
        uri:     'webhook/test',
        payload: {
          header_content_type: header_content_type
        }.compact
      )
    end
  end
end
