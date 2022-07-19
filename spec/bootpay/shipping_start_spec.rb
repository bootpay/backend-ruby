# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "shipping start" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.shipping_start(
        receipt_id:      "62d61a831fc192036b7c7c5f",
        tracking_number: '123456',
        delivery_corp:   'CJ대한통운',
        redirect_url:    'https://dev-api.bootpay.co.kr/callback',
        user:            {
          username: '부트페이',
          phone:    '01000000000',
          address:  '서울특별시 구로구 디지털로 26길 61',
          zipcode:  '08882'
        }
      )
      print response.data.to_json
    end
  end
end
