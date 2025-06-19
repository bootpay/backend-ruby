# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "add user group" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
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
