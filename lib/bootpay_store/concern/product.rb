module BootpayStore::Concern::Product
  extend ActiveSupport::Concern

  included do
    # 상품 목록을 조회한다 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
    # @date: 26-08-14 ⚠️ keyword 는 서버(v1/products_controller#index)가 읽지 않는다.
    #   컨트롤러는 page/limit/category_id/ex_uid/sort 만 사용 — keyword 를 보내도 조용히 무시된다.
    #   하위호환 때문에 인자는 남겨두되, 검색이 필요하면 서버 지원 추가가 선행되어야 한다.
    def products(page: 1, limit: 20, category_id: nil, sort: nil, keyword: nil, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     'products',
        method:  :get,
        headers: {
                   'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
                   'Bootpay-User-JWT' => user_jwt
                 }.compact,
        params:  {
                   page:        page,
                   limit:       limit,
                   category_id: category_id,
                   sort:        sort,
                   keyword:     keyword
                 }.compact
      )
    end

    # 상품 상세를 조회한다 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
    def product_detail(product_id:, user_jwt: nil, idempotency_key: nil)
      request(
        uri:     "products/#{product_id}",
        method:  :get,
        headers: {
                   'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
                   'Bootpay-User-JWT' => user_jwt
                 }.compact
      )
    end

    # 상품 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-10-10
    # @date: 26-08-14 product_detail 과 uri·동작이 같다(차이는 user_jwt 인자 유무).
    #   중복이지만 기존 사용자가 있을 수 있어 제거하지 않는다 — 신규 코드는 product_detail 을 쓸 것.
    def lookup_product(product_id:, idempotency_key: nil)
      request(
        uri:     "products/#{product_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
        }
      )
    end

    # 상품을 등록한다 (POST /v1/products)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # images 가 있으면 multipart, 없으면 JSON 으로 보낸다.
    # 컨트롤러가 읽는 필드는 _product_params 참조 — 여기 명시하지 않은 값도 attrs 로 그대로 전달된다.
    def product_create(name:, display_price: nil, desc: nil, content: nil, category_id: nil,
                       type: nil, stock: nil, status_sale: nil, status_display: nil,
                       use_subscription: nil, subscription_setting_id: nil,
                       images: nil, save_by: nil, idempotency_key: nil, **attrs)
      payload = {
        name:                    name,
        display_price:           display_price,
        desc:                    desc,
        content:                 content,
        category_id:             category_id,
        type:                    type,
        stock:                   stock,
        status_sale:             status_sale,
        status_display:          status_display,
        use_subscription:        use_subscription,
        subscription_setting_id: subscription_setting_id,
        save_by:                 save_by
      }.merge(attrs).compact

      headers = {
        'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
        'Bootpay-Role'    => 'manager'
      }

      if images.present?
        form = payload.each_with_object({}) { |(k, v), h| h[k.to_s] = multipart_value(v) }
        Array(images).each_with_index { |image, i| form["images[#{i}]"] = multipart_file(image) }
        post_multipart(uri: 'products', form: form, headers: headers)
      else
        request(uri: 'products', method: :post, headers: headers, payload: payload)
      end
    end

    # 상품을 수정한다 (PUT /v1/products/:id)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # 바뀐 값만 보내면 된다. category_id 는 키 존재 여부로 '해제 의사'를 판별하므로 주의.
    def product_update(product_id:, name: nil, display_price: nil, desc: nil, content: nil,
                       category_id: nil, stock: nil, status_sale: nil, status_display: nil,
                       save_by: nil, idempotency_key: nil, **attrs)
      request(
        uri:     "products/#{product_id}",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        },
        payload: {
                   name:           name,
                   display_price:  display_price,
                   desc:           desc,
                   content:        content,
                   category_id:    category_id,
                   stock:          stock,
                   status_sale:    status_sale,
                   status_display: status_display,
                   save_by:        save_by
                 }.merge(attrs).compact
      )
    end

    # 상품을 삭제한다 (DELETE /v1/products/:id)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    def product_delete(product_id:, idempotency_key: nil)
      request(
        uri:     "products/#{product_id}",
        method:  :delete,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        }
      )
    end

    # 상품 판매/노출 상태를 변경한다 (PUT /v1/products/:id/status)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # 컨트롤러 _status_params 기준. 재고(stock)는 여기가 아니라 product_update 로 바꾼다.
    def product_status(product_id:, status_sale: nil, status_display: nil, status_frozen: nil,
                       status_review: nil, use_display_period: nil, display_start_at: nil, display_end_at: nil,
                       use_sale_period: nil, sale_start_at: nil, sale_end_at: nil,
                       idempotency_key: nil, **attrs)
      request(
        uri:     "products/#{product_id}/status",
        method:  :put,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'    => 'manager'
        },
        payload: {
                   status_sale:        status_sale,
                   status_display:     status_display,
                   status_frozen:      status_frozen,
                   status_review:      status_review,
                   use_display_period: use_display_period,
                   display_start_at:   display_start_at,
                   display_end_at:     display_end_at,
                   use_sale_period:    use_sale_period,
                   sale_start_at:      sale_start_at,
                   sale_end_at:        sale_end_at
                 }.merge(attrs).compact
      )
    end
  end
end
