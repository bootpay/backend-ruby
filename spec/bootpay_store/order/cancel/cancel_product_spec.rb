# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order cancel product" do
    api   = BootpayStore::RestClient.new(
      server_key:  '644642d87ae4e600391a7cd3',
      private_key: 'tnNiygbEITl62dmDr9zf3uJFMFtT+R3AuB2eEnDqR4M=',
      mode:        'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.request_order_cancel(
        order_number:       '25041415037360150093',
        cancel_products:    [
                              {
                                product_id:        '6709c58f7975188b6e6fce93',
                                product_option_id: '67f5b8e9b0baf4514ad93e31',
                                cancel_quantity:   1
                              }
                            ],
        cancel_immediately: true
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
