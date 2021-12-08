# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "destroy billing key" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    '***REMOVED***',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.destroy_billing_key(
        '61a8879d1fc192030b0938fe'
      )
      print response.data.to_json
    end
  end
end
