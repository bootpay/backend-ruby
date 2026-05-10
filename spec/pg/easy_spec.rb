# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "easy payment" do
    puts "easy payment"
    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.get_user_token(
        user_id: '1234',
        email: 'test@gmail.com',
        name: '테스트',
      )
      puts response.data.to_json
    end
  end
end
