module BootpayStore::Concern::Invoice
  extend ActiveSupport::Concern

  included do
    # 청구서를 생성한다
    # Comment by GOSOMI
    # @date: 2025-10-03
    def request_checkout(sdk: false, idempotency_key: nil, name:, memo: nil, user: {}, products: [], price: 0, tax_free_price: 0, delivery_price: 0,
                         redirect_url: nil, request_id: nil, use_notification: false, use_auto_login: false, expired_at: nil, metadata: {},
                         webhook_url: nil, header_content_type: 'application/json', usage_api_url: nil, extra: {})
      request(
        uri:     'invoices',
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload:
                 {
                   sdk:                 sdk,
                   name:                name,
                   memo:                memo,
                   user:                user,
                   products:            products,
                   price:               price,
                   tax_free_price:      tax_free_price,
                   delivery_price:      delivery_price,
                   redirect_url:        redirect_url,
                   request_id:          request_id,
                   use_notification:    use_notification,
                   use_auto_login:      use_auto_login,
                   expired_at:          expired_at,
                   metadata:            metadata,
                   webhook_url:         webhook_url,
                   header_content_type: header_content_type,
                   usage_api_url:       usage_api_url,
                   extra:               extra
                 }.compact
      )
    end

    alias :create_invoice :request_checkout
  end
end