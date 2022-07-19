module Bootpay::Concern::Escrow
  extend ActiveSupport::Concern

  included do
    # 배송시작 API
    # Comment by Gosomi
    # Date: 2021-12-14
    def shipping_start(receipt_id:, tracking_number:, delivery_corp:, shipping_prepayment: true,
                       shipping_day: 5, user: nil, company: {}, redirect_url: nil)
      request(
        method:  :put,
        uri:     "escrow/shipping/start/#{receipt_id}",
        payload: {
          tracking_number:     tracking_number,
          delivery_corp:       delivery_corp,
          shipping_prepayment: shipping_prepayment,
          shipping_day:        shipping_day,
          user:                user,
          company:             company,
          redirect_url:        redirect_url
        }
      )
    end
  end
end