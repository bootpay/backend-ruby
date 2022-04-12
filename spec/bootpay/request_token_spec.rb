# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "request token" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      # mode:           'development'
    )
    response = api.request_access_token
    print response.data.to_json
  end
end
