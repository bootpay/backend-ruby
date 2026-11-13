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
      response = api.supervisor_request_order_subscription_pause(
        order_subscription_id: '6973336e4346c992dc19ed61',
        paused_at:             Time.current.strftime('%Y-%m-%d %H:%M:%S'),
        expected_resume_at:    (Time.current + 20.seconds).strftime('%Y-%m-%d %H:%M:%S')
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
