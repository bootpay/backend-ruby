# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "token" do
    api         = BootpayStore::RestClient.new(
      server_key:     '67c92fb8d01640bb9859c612',
      private_key:    'ugaqkJ8/Yd2HHjM+W1TF6FZQPTmvx1rny5OIrMqcpTY=',
      mode:           'development'
    )
    response = api.request_access_token
    # print response.data.to_json
    json = JSON.parse(response.data.to_json)
    puts json
    puts json['access_token']
    # print response.data.to_json
  end
end
