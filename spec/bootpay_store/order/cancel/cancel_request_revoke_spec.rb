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
      response = api.request_order_cancel_revoke(
        order_cancellation_request_id: '67f8967429ef1f27072deee9'
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
