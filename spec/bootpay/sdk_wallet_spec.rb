# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "get wallets" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.request_user_token(
        user_id: 'gosomi1'
      )
      user_token = response.data[:user_token]
      if response.success?
        response = api.wallets(user_token)
        print response.data.to_json
      end
    end
  end
end
