# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "submit" do
    puts "submit"
    receipt_id = '612e09260d681b0021e61ab9'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.server_submit(receipt_id)
      print  response.data.to_json
    end
  end 
end
