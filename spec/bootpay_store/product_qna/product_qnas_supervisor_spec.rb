# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "product qnas supervisor" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.product_qnas(
        view:       'all',
        supervisor: true
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
