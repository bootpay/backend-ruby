# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "get mall setting" do
    api      = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    response = api.get_mall_setting
    puts response.data.to_json
  end
end
