# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "phone exist" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.phone_exist(
        phone: '01000000000' # 전화번호를 입력하세요 (예: 01000000000, 010-0000-0000, 010 0000 0000 등)
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
