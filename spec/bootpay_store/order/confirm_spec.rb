# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order confirm" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.order_confirm(
        order_number: "25110364369576065094"
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
