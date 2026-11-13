# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "order_subscriptions rejected" do
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
    # token = api.request_access_token
    # if token.success?
    #   response = api.supervisor_request_order_subscription_terminate(
    #     order_subscription_id: '69701b495854363bb96c998a'
    #   )
    #   puts response.data.to_json
    # else
    #   puts token.data
    # end
    response = api.supervisor_request_order_subscription_terminate(
      order_subscription_id: '69701b495854363bb96c998a'
    )
    puts response.data.to_json
  end
end
