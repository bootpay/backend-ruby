# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "orders" do
    api = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )

    # api   = BootpayStore::RestClient.new(
    #   client_key: ENV['BP_CLIENT_KEY'],
    #   secret_key: ENV['BP_SECRET_KEY'],
    #   mode:       'stage'
    # )
    token = api.request_access_token
    if token.success?
      response = api.order_detail(order_number: "26071438549224114186")
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
