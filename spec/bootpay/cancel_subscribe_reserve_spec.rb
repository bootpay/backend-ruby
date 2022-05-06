# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "cancel subscribe reserve" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    if api.request_access_token.success?
      response = api.subscribe_payment_reserve(
        billing_key:        '623028630e019e036fe98478',
        order_name:         '테스트결제',
        price:              1000,
        order_id:           Time.current.to_i,
        user:               {
          phone:    '01000000000',
          username: '홍길동',
          email:    'test@bootpay.co.kr'
        },
        reserve_execute_at: (Time.current + 5.seconds).iso8601
      )
      puts response.data.to_json
      if response.success?
        puts "cancel reserve_id: #{response.data[:reserve_id]}"
        cancel = api.cancel_subscribe_reserve(response.data[:reserve_id])
        puts cancel.data.to_json
      end
    end
  end
end
