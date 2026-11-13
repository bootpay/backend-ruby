# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "delete user group" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.delete_user_group(
        user_group_id: '68526e43ecd1ce82158b6b1d'
      )
      puts response.data.to_json
      # 68526e43ecd1ce82158b6b1d
    else
      puts token.data
    end
  end
end
