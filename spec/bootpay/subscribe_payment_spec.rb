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
      response = api.request_subscribe_card_payment(
        billing_key: '66542dfb4d18d5fc7b43e1b6',
        order_name:  '테스트결제',
        price:       100,
        card_quota:  '00',
        order_id:    Time.current.to_i,
        user:        {
          phone:    '01000000000',
          username: '홍길동',
          email:    'test@bootpay.co.kr'
        }
      )
      print response.data.to_json
    end
  end
end
