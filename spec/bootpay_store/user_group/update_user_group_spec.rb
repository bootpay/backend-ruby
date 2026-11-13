# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "update user group" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.update_user_group(
        user_group_id:   '6763ce2b817af6a00e0fbfbe',
        company_name:    '부트페이1',
        business_number: '1234567890',
        manager_name:    '윤태섭',
        ceo_name:        '윤태섭'
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
