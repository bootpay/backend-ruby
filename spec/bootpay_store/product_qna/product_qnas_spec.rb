# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "product qnas" do
    api      = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    response = api.product_qnas(
      product_id: '6a8ec75d0ac933f2aabc19ce',
      page:       1,
      limit:      20
    )
    puts JSON.pretty_generate(response.data)
  end
end
