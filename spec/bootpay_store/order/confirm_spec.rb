# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order confirm" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
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
