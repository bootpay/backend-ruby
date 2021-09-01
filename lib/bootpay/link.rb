
# Comment by ehowlsla
# Date: 2021-08-31
# @return [Hash]
module Bootpay::Link
  extend ActiveSupport::Concern

  included do
    def request_link(pg: nil, method: nil, methods: nil, price: nil, order_id: nil, params: nil, tax_free: nil, name: nil,
                     user_info: {id: nil, username: nil, email: nil, phone: nil, gender: nil, area: nil, birth: nil},
                     items: nil, return_url: nil,
                     extra: {escrow: nil, expire_month: nil, quota: nil, subscribe_test_payment: nil, disp_cash_result: nil, offer_period: nil, seller_name: nil, theme: nil, custom_background: nil, custom_font_color: nil })
      request(
        uri: 'request/payment',
        payload:
          {
            pg:               pg,
            method:           method,
            methods:          methods,
            price:            price,
            order_id:         order_id,
            params:           params,
            tax_free:         tax_free,
            name:             name,
            user_info:        user_info,
            items:            items,
            return_url:       return_url,
            extra:            extra.values.any? {|v|v != nil} ? extra : nil
          }.compact
      )
    end
  end
end