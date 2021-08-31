# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  # 빌링키 발급받기
  it "get billing key" do
    print "\nget billing key\n"

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.get_billing_key(
        order_id:         '1234',
        pg:               'nicepay',
        item_name:        '테스트 결제',
        card_no:          '', # 값 할당 필요
        card_pw:          '', # 값 할당 필요
        expire_year:      '', # 값 할당 필요
        expire_month:     '', # 값 할당 필요
        identify_number:  '' # 값 할당 필요
      )
      print response.data.to_json
    end
  end

  # 빌링키 삭제하기
  it "destroy billing key" do
    print "\ndestroy billing key\n"
    billing_key = '612debc70d681b0039e6133d'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
      )
    if api.request_access_token.success?
      response = api.destroy_billing_key(billing_key)
      print response.data.to_json
    end
  end

  # 빌링키로 결제 요청하기
  it "subscribe billing" do
    print "\nsubscribe billing\n"
    billing_key = '612deb53019943001fb52312'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
      )
    if api.request_access_token.success?
      response = api.subscribe_billing(
        billing_key:    billing_key,
        item_name:      '테스트 결제',
        price:          1000,
        tax_free:       1000,
        order_id:       '1234'
      )
      print response.data.to_json
    end
  end

  # 빌링키로 결제 예약 후 바로 취소하기
  it "reserve billing" do
    print "\nreserve billing\n"
    billing_key = '612deb53019943001fb52312'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
      )
    if api.request_access_token.success?
      response = api.subscribe_reserve_billing(
        billing_key:    billing_key,
        item_name:      '테스트 결제',
        price:          1000,
        tax_free:       1000,
        order_id:       '1234'
      )
      print response.data.to_json

      reserve_id = response.data[:data][:reserve_id]
      response = api.subscribe_reserve_cancel(reserve_id)
      print response.data.to_json
    end
  end
end
