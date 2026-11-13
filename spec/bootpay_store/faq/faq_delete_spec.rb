# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "faq delete" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.faq_delete(
        faq_id: 'FAQ_ID'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
