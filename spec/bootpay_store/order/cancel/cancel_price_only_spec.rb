# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order cancel price only" do
    api   = BootpayStore::RestClient.new(
      server_key:  '644642d87ae4e600391a7cd3',
      private_key: 'tnNiygbEITl62dmDr9zf3uJFMFtT+R3AuB2eEnDqR4M=',
      mode:        'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.request_order_cancel(
        order_number: '25041526449271573094',
        cancel_immediately: true
        # cancel_price: 8500
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
