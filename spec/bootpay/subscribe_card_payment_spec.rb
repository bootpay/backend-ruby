# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.request_subscribe_card_payment(
        billing_key: '62d903671fc192036b1b3b56',
        order_name:   '테스트결제',
        price:       10000,
        card_quota:  '00',
        order_id:    Time.current.to_i,
        user: {
          phone: '01000000000',
          username: '홍길동',
          email: 'test@bootpay.co.kr'
        }
      )
      print response.data.to_json
    end
  end
end