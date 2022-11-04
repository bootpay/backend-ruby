# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "request authentication" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    # api = Bootpay::RestClient.new(
    #   application_id: '62d60a39e38c3000235afe63',
    #   private_key:    'Nuu09hRbQ+8EmEfLEu1HeaLwsZd38BJmtwhLa1pxI24=',
    #   mode:           'stage'
    # )
    if api.request_access_token.success?
      response = api.realarm_authentication('63647ea31fc1920373e6d8f3')
      print response.data.to_json
    end
  end
end
