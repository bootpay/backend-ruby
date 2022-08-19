module Bootpay::Concern::Seller
  extend ActiveSupport::Concern

  included do
    # 현재 사용가능한 결제수단 목록 보기
    # Comment by Gosomi
    # Date: 2022-08-19
    def lookup_payment_methods
      request(
        uri:    'seller/payment/method',
        method: :get
      )
    end
  end
end