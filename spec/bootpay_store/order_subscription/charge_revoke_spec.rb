# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order subscription charge revoke" do
    api = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
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
