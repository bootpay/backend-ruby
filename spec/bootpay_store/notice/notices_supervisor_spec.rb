# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "notices supervisor" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.notices(
        view:       'all',
        supervisor: true
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
