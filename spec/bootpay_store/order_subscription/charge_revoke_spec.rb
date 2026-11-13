# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order subscription charge revoke" do
    api = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.supervisor_request_order_subscription_charge_revoke(
        charge_key: 'charge-key',
        user:       {
          username: '홍길동',
          phone:    '01000000000'
        }
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
