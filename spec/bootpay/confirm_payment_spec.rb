# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "confirm payment" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.confirm_payment(
        "61d3d41b1fc19202e483320b"
      )
      print response.data.to_json
    end
  end
end
