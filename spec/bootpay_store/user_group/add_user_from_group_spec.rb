# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "add user group" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.add_user_to_group(
        user_group_id: '6763758e817af6a00e0fbf62',
        user_id:       '6763ce2b817af6a00e0fbfbd'
      )
      puts response.data.to_json
      # 68526e43ecd1ce82158b6b1d
    else
      puts token.data
    end
  end
end
