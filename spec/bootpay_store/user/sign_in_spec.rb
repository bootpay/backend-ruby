# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "sign in" do
    api      = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.sign_in(
        name: 'test',
        email: 'test@bootpay.co.kr',
        phone: '01012345678',

      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
