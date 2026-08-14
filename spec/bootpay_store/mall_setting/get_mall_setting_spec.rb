# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "get mall setting" do
    api      = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    response = api.get_mall_setting
    puts response.data.to_json
  end
end
