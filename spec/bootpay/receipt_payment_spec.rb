# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "receipt payment data" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    '***REMOVED***',
      mode:           'development'
    )
    # api = Bootpay::RestClient.new(
    #   application_id: '62d60a39e38c3000235afe63',
    #   private_key:    'Nuu09hRbQ+8EmEfLEu1HeaLwsZd38BJmtwhLa1pxI24=',
    #   mode:           'stage'
    # )
    if api.request_access_token.success?
      response = api.receipt_payment(
        "632439131fc192036bac6308"
      )
      print response.data.to_json
    end
  end
end
