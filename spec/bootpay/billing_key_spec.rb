# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.subscribe_billing_key(
        "61832d311fc19202de55794c"
      )
      print response.data.to_json
    end
  end
end
