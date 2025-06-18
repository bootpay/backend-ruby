# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "business number exist" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.group_business_number_exist(
        business_number: '1234567890' # 사업자등록번호를 입력하세요
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
