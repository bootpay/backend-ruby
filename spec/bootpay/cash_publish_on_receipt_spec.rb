# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "certificate authentication" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.cash_receipt_publish_on_receipt(
        receipt_id:  "62e24a641fc192036b1b3cf9",
        username:    '테스트',
        email:       'test@bootpay.co.kr',
        phone:       '01000000000',
        identity_no: '01000000000'
      )
      print response.data.to_json
      print Time.now
    end
  end
end
