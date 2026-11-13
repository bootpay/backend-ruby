# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "id exist" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.id_exist(
        id: 'bootpay'
      )
      puts response.data.to_json
    else
      puts token.data
    end
  end
end
