# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "token" do
    # api      = BootpayStore::RestClient.new(
    #   server_key:  '67c92fb8d01640bb9859c612',
    #   private_key: ENV['BOOTPAY_PRIVATE_KEY'],
    #   mode:        'development'
    # )
    api      = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    response = api.request_access_token
    puts response.data

    "f32b56e3cba4de2c2a9819cf0bde00729e7772bae46e4d7c681e14f95cf5814a"
  end
end
