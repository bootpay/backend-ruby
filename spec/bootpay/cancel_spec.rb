# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "cancel payment" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.cancel_payment(
        receipt_id:      "60dac1611fc192010874cf01",
        # cancel_price:    200,
        cancel_username:        'test',
        cancel_message:         'test'
      )
      print response.data.to_json
    end
  end
end
