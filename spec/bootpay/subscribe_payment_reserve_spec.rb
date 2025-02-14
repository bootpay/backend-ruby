# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    api = Bootpay::RestClient.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
      mode:           'production'
    )
    # api = Bootpay::RestClient.new(
    #   application_id: '59b731f084382614ebf72215',
    #   private_key:    'WwDv0UjfwFa04wYG0LJZZv1xwraQnlhnHE375n52X0U=',
    #   mode:           'stage'
    # )
    if api.request_access_token.success?
      response = api.subscribe_payment_reserve(
        # billing_key:        '62820fa61fc19202e5ef240e',
        billing_key:        '66f9da41e1afdbe0495e6526',
        order_name:         '테스트결제',
        price:              100,
        order_id:           Time.current.to_i,
        user:               {
          phone:    '01000000000',
          username: '홍길동',
          email:    'test@bootpay.co.kr'
        },
        reserve_execute_at: (Time.current + 5.seconds).iso8601
      )
      print response.data.to_json
    end
  end
end
