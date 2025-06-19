# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "update user group" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.create_user_group(
        uid:             'bootpay-test',
        company_name:    '부트페이1',
        business_number: '1234567890',
        manager_name:    '윤태섭',
        ceo_name:        '윤태섭'
      )
      puts response.data.to_json
      # 68526e43ecd1ce82158b6b1d
    else
      puts token.data
    end
  end
end
