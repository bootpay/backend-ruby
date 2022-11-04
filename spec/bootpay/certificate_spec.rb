# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "certificate authentication" do
    # api = Bootpay::RestClient.new(
    #   application_id: '5c5cf060396fa678c275875a',
    #   private_key:    'WaS7S2Lb44K5uE7OtCpsTIN/bTneH4fWnILpPStkCNo=',
    #   mode:           'production'
    # )

    api = Bootpay::RestClient.new(
      application_id: '59b731f084382614ebf72215',
      private_key:    'WwDv0UjfwFa04wYG0LJZZv1xwraQnlhnHE375n52X0U=',
      mode:           'stage'
    )
    if api.request_access_token.success?
      response = api.certificate(
        "6327aaf743c9be001679f5cf"
      )
      print response.data.to_json
    end
  end
end
