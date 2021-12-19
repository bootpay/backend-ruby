# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "cancel cash receipt" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.cancel_cash_receipt(
        receipt_id:      '61baf1d91fc1920311e080c4',
        cancel_username: 'test',
        cancel_message:  'test 취소'
      )
      print response.data.to_json
    end
  end
end
