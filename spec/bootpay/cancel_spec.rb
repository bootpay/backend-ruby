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
        receipt_id:      "61baf7e81fc1920311e08106",
        cancel_price:    1000,
        cancel_username: 'test_user',
        cancel_message:  'test_message',
      # items:           [
      #                    {
      #                      id:    'test_1',
      #                      name:  '테스트 아이템2',
      #                      price: 500,
      #                      qty:   1
      #                    }
      #                  ]
      )
      print response.data.to_json
    end
  end
end
