# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    # api = Bootpay::RestClient.new(
    #   application_id: '59bfc738e13f337dbd6ca48a',
    #   private_key:    '***REMOVED***',
    #   mode:           'development'
    # )
    api         = Bootpay::RestClient.new(
      application_id: '59b731f084382614ebf72215',
      private_key:    '***REMOVED***',
      mode:           'stage'
    )
    if api.request_access_token.success?
      response = api.lookup_subscribe_billing_key(
        "633f69a3d01c7e002a4c75ea"
      )
      print response.data.to_json
    end
  end
end
