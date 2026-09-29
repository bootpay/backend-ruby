# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "reviews" do
    api      = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    response = api.reviews(
      user_id: 'USER_ID',
      page:    1,
      limit:   20
    )
    puts JSON.pretty_generate(response.data)
  end
end
