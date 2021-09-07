# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "link payment" do
    puts "link payment"
    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.request_link(
        pg:             'nicepay',
        price:          1000,
        tax_free:       1000,
        order_id:       '1234',
        name:           '결제테스트'
      )
      puts response.data.to_json
    end
  end
end
