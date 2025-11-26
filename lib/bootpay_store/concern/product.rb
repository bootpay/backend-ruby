module BootpayStore::Concern::Product
  extend ActiveSupport::Concern

  included do
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
