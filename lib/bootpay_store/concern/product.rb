module BootpayStore::Concern::Product
  extend ActiveSupport::Concern

  included do
    # 상품 목록을 조회한다 (V1 Mall API)
    # Comment by Codex
    # @date: 2026-02-23
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
    def lookup_product(product_id:, idempotency_key: nil)
      request(
        uri:     "products/#{product_id}",
        method:  :get,
        headers: {
          'Idempotency-Key' => idempotency_key.presence || SecureRandom.uuid,
        }
      )
    end
  end
end
