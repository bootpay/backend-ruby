# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "phone exist" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
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
