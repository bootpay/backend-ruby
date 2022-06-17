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
        receipt_id:      "62a818cf1fc19203154a8f2e",
        tracking_number: '123456',
        delivery_corp:   'CJ대한통운',
        user:            {
          username: '강훈',
          phone:    '01095735114',
          address:  '경기도 화성시 동탄기흥로 277번길 59',
          zipcode:  '08490'
        }
      )
      print response.data.to_json
    end
  end
end
