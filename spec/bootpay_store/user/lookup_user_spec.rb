# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "lookup user" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.lookup_user('6763ce2b817af6a00e0fbfbd')
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
