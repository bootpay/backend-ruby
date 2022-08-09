# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "request cash receipt" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.request_cash_receipt(
        pg:                '토스',
        price:             1000,
        tax_free:          0,
        order_name:        '테스트',
        cash_receipt_type: '소득공제',
        user:              {
          username: '부트페이',
          phone:    '01000000000',
          email:    'bootpay@bootpay.co.kr'
        },
        identity_no:       '0100000000',
        purchased_at:      Time.current.strftime('%Y-%m-%d %H:%M:%S'),
        order_id:          Time.current.to_f
      )
      print response.data.to_json
    end
  end
end
