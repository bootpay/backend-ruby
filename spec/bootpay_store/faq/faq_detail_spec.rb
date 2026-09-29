# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "faq detail" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.faq_detail(
        faq_id: 'FAQ_ID'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
