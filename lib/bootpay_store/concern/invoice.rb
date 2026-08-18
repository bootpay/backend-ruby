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

    # 청구서 목록을 조회한다 (GET /v1/invoices)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # 응답은 { list: [...], count: N } 구조다 ({ items, total } 아님 — Node SDK 타입선언이 틀렸던 지점).
    # 서버 기본 limit 은 24.
    def invoice_list(page: 1, limit: 24, keyword: nil, cs_type: nil, user_id: nil,
                     product_type: nil, css_at: nil, cse_at: nil, idempotency_key: nil)
      request(
        uri:     'invoices',
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        params:  {
                   page:         page,
                   limit:        limit,
                   keyword:      keyword,
                   cs_type:      cs_type,
                   user_id:      user_id,
                   product_type: product_type,
                   css_at:       css_at,
                   cse_at:       cse_at
                 }.compact
      )
    end

    # 청구서 상세를 조회한다 (GET /v1/invoices/:id)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    def invoice_detail(invoice_id:, idempotency_key: nil)
      request(
        uri:     "invoices/#{invoice_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        }
      )
    end

    # 청구서를 재안내한다 (POST /v1/invoices/:id/notify)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # send_types 미전달 시 서버가 빈 배열로 처리한다.
    # ⚠️ 실제 고객에게 알림이 발송되므로 테스트 호출 주의.
    def invoice_notify(invoice_id:, send_types: nil, idempotency_key: nil)
      request(
        uri:     "invoices/#{invoice_id}/notify",
        method:  :post,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'user'
        },
        payload: { send_types: send_types }.compact
      )
    end
  end
end