# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "cancel payment" do
    # api = Bootpay::RestClient.new(
    #   application_id: '59bfc738e13f337dbd6ca48a',
    #   private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
    #   mode:           'development'
    # )
    api = Bootpay::RestClient.new(
      application_id: '59b731f084382614ebf72215',
      private_key:    'WwDv0UjfwFa04wYG0LJZZv1xwraQnlhnHE375n52X0U=',
      mode:           'stage'
    )
    if api.request_access_token.success?
      response = api.cancel_payment(
        receipt_id:      "62ddd3c556d0c60016969657",
        cancel_price:    1111,
        cancel_tax_free: 0,
        cancel_username: 'test_user',
        cancel_message:  'test_message',
      )
      print response.data.to_json
    end
  end
end
