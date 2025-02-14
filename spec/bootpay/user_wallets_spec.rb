# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    # api = Bootpay::RestClient.new(
    #   application_id: '59bfc738e13f337dbd6ca48a',
    #   private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
    #   mode:           'development'
    # )
    api = Bootpay::RestClient.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
      mode:           'production'
    )
    if api.request_access_token.success?
      response = api.user_wallets(
        user_id: 'bootpay',
        sandbox: true
      )
      print response.data.to_json
    end
  end
end
