
# bootpay dev api
# Comment by Gosomi
# Date: 2020-06-18
# @return [Hash]
module Bootpay::Naverpay
  extend ActiveSupport::Concern

  included do
    def naverpay_item_response(data)
      request(
        uri: 'npay/product',
        payload: data
      )
    end
  end
end