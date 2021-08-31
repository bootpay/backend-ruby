# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "request token" do
    print "\nrequest token\n"
    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    response = api.request_access_token
    print response.data
  end
end
