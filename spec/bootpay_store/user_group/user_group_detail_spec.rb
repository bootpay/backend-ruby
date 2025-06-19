# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "user group detail" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.lookup_user_group(user_group_id: '68526e43ecd1ce82158b6b1d')
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
