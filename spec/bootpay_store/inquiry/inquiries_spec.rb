# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "inquiries" do
    api      = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    response = api.inquiries(
      user_id: 'gosomi84',
      page:    1,
      limit:   20
    )
    puts JSON.pretty_generate(response.data)
  end
end
