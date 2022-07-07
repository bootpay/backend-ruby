# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "cancel payment" do
    # api = Bootpay::RestClient.new(
    #   application_id: '59bfc738e13f337dbd6ca48a',
    #   private_key:    '***REMOVED***',
    #   mode:           'development'
    # )
    api = Bootpay::RestClient.new(
      application_id: '59b731f084382614ebf72215',
      private_key:    '***REMOVED***',
    # mode:           'development'
    )
    if api.request_access_token.success?
      response = api.cancel_payment(
        receipt_id:      "62b1c34e778102001f4a4fa8",
        cancel_price:    1000,
        cancel_tax_free: 0,
        cancel_username: 'test_user',
        cancel_message:  'test_message',
      )
      print response.data.to_json
    end
  end
end
