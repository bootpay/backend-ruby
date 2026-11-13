# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order_subscriptions" do
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
      response = api.order_subscription_detail(order_subscription_id: '64b0f1c3d4e2f00001a2b3c4')
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
