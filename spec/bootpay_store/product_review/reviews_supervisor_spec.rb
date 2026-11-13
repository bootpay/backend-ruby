# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "reviews supervisor" do
    api      = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    response = api.reviews(
      view:       'all',
      supervisor: true,
      product_id: '6a8ec75d0ac933f2aabc19ce'
    )
    puts JSON.pretty_generate(response.data)
  end
end
