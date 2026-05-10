# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "cancel payment" do
    puts "cancel payment"
    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.cancel_payment(
        receipt_id:      "612df0250d681b001de61de6",
        # cancel_price:    200,
        cancel_username:        'test',
        cancel_message:         'test'
      )
      puts response.data.to_json
    end
  end
end
