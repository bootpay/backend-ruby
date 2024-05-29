# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    # api = Bootpay::RestClient.new(
    #   application_id: '59bfc738e13f337dbd6ca48a',
    #   private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
    #   mode:           'development'
    # )
    api = Bootpay::RestClient.new(
      application_id: '59b731f084382614ebf72215',
      private_key:    'WwDv0UjfwFa04wYG0LJZZv1xwraQnlhnHE375n52X0U=',
      mode:           'production'
    )
    if api.request_access_token.success?
      res1 = api.request_subscribe_automatic_transfer_billing_key(
        pg:         'nicepay',
        order_name: '테스트 결제',
        price:       100,
        tax_free:    0,
        subscription_id:    Time.current.to_i,
        username:    '홍길동',
        user:        {
          phone:    '01012341234',
          username: '홍길동',
          email:    'test@bootpay.co.kr'
        },
        bank_name: '국민',
        bank_account: '675123412342472',
        identity_no: '901014',
        cash_receipt_identity_no: '01012341234',
        phone: '01012341234',
      )
      print res1.data.to_json

      res2 = api.publish_automatic_transfer_billing_key(receipt_id: res1.data[:receipt_id])
      print "\n\n" + res2.data.to_json


    end
  end
end
