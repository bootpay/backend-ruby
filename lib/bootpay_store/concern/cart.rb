module BootpayStore::Concern::Cart
  extend ActiveSupport::Concern

  included do
    # 장바구니 주문 미리보기 (POST /v1/cart/order-preview)
    # @comment_by Claude (alfred)
    # @date: 26-11-13
    # 회원 선택: 비회원도 호출 가능 (user_id·login_id 는 본문, user_jwt 는 헤더)
    def cart_order_preview(cart_items:, shipping_address: nil, user_id: nil, login_id: nil, user_jwt: nil,
                           idempotency_key: nil)
      request(
        uri:     'cart/order-preview',
        method:  :post,
        headers: {
          'Idempotency-Key'  => idempotency_key.presence || SecureRandom.uuid,
          'Bootpay-Role'     => 'user',
          'Bootpay-User-JWT' => user_jwt
        }.compact,
        payload: {
                   cart_items:       cart_items,
                   shipping_address: shipping_address,
                   user_id:          user_id,
                   login_id:         login_id
                 }.compact
      )
    end
  end
end
