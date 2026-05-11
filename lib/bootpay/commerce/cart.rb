# frozen_string_literal: true

module Bootpay
  module Commerce
    class CartModule
      def initialize(bootpay)
        @bootpay = bootpay
      end

      # 주문 미리보기 (배송비/할인 권위적 계산)
      # POST /v1/cart/order-preview
      #
      # member_mode='guest' (기본): cart_items 필수
      # member_mode='member': 서버 장바구니 사용 (user 토큰 필요)
      def order_preview(params = {})
        @bootpay.post('cart/order-preview', params)
      end
    end
  end
end
