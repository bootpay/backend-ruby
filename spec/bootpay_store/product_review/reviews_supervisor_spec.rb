# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "reviews supervisor" do
    api      = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
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
