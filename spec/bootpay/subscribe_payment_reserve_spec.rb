# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    # api = Bootpay::RestClient.new(
    #   application_id: '59b731f084382614ebf72215',
    #   private_key:    'WwDv0UjfwFa04wYG0LJZZv1xwraQnlhnHE375n52X0U='
    # )
    if api.request_access_token.success?
      response = api.subscribe_payment_reserve(
        # billing_key:        '62820fa61fc19202e5ef240e',
        billing_key:        '628c0d0d1fc19202e5ef2866',
        order_name:         '테스트결제',
        price:              1000,
        order_id:           Time.current.to_i,
        user:               {
          phone:    '01000000000',
          username: '홍길동',
          email:    'test@bootpay.co.kr'
        },
        reserve_execute_at: (Time.current + 30.seconds).iso8601
      )
      print response.data.to_json
    end
  end
end
