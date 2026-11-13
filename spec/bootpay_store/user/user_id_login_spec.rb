# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "user login" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.login_by_user_id(user_id: '6763ce2b817af6a00e0fbfbd')
      puts response.data
    else
      puts token.data
    end
  end
end
