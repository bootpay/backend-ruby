# frozen_string_literal: true

RSpec.describe Bootpay::Api do



  # 빌링키 발급받기
  it "get billing key" do
    puts "get billing key"

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
    )
    if api.request_access_token.success?
      response = api.get_billing_key(
        order_id:         '1234',
        pg:               'nicepay',
        item_name:        '테스트 결제',
        card_no:          '5570**********1074', # 실제 테스트시에는 *** 마스크처리가 아닌 숫자여야 함
        card_pw:          '**', # 실제 테스트시에는 *** 마스크처리가 아닌 숫자여야 함
        expire_year:      '**', # 실제 테스트시에는 *** 마스크처리가 아닌 숫자여야 함
        expire_month:     '**', # 실제 테스트시에는 *** 마스크처리가 아닌 숫자여야 함
        identify_number:  '**' # 주민등록번호 또는 사업자 등록번호 (- 없이 입력)
      )
      puts response.data.to_json
    end
  end

  # 빌링키 삭제하기
  it "destroy billing key" do
    puts "destroy billing key"
    billing_key = '612debc70d681b0039e6133d'

    api = Bootpay::Api.new(
      application_id: '5b8f6a4d396fa665fdc2b5ea',
      private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw=',
      )
    if api.request_access_token.success?
      response = api.destroy_billing_key(billing_key)
      puts response.data.to_json
    end
  end

  # 빌링키로 결제 요청하기
  it "subscribe billing" do
    puts "subscribe billing"
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
      puts response.data.to_json
    end
  end

  # 빌링키로 결제 예약 후 바로 취소하기
  it "reserve billing" do
    puts "reserve billing"
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
      puts response.data.to_json

      reserve_id = response.data[:data][:reserve_id]
      response = api.subscribe_reserve_cancel(reserve_id)
      puts response.data.to_json
    end
  end
end
