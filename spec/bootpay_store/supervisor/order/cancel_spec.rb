# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order cancel" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.supervisor_request_order_cancel(order_number: Time.current.to_i)
      puts response.data
    else
      puts token.data
    end
  end
end
