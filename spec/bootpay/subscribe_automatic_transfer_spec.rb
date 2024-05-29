# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "billing key" do
    # api = Bootpay::RestClient.new(
    #   application_id: '59bfc738e13f337dbd6ca48a',
    #   private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
    #   mode:           'development'
    # )
    api = Bootpay::RestClient.new(
      application_id: '59b731f084382614ebf72215',
      private_key:    'WwDv0UjfwFa04wYG0LJZZv1xwraQnlhnHE375n52X0U=',
      mode:           'production'
    )
    if api.request_access_token.success?
      # res1 = api.request_subscribe_automatic_transfer_billing_key(
      #   pg:         'nicepay',
      #   order_name: '테스트 결제',
      #   price:       100,
      #   tax_free:    0,
      #   subscription_id:    Time.current.to_i,
      #   username:    '윤태섭',
      #   user:        {
      #     phone:    '01040334678',
      #     username: '윤태섭',
      #     email:    'ehowlsla@bootpay.co.kr'
      #   },
      #   bank_name: '국민',
      #   bank_account: '67560101092472',
      #   identity_no: '8610141038021',
      #   cash_receipt_identity_no: '01040334678',
      #   phone: '01040334678',
      # )
    #   print res1.data.to_json
    #
    # #   {"receipt_id":"662065c244772e8816f0cbfa","order_id":"1713399234","price":100,"tax_free":0,"cancelled_price":0,"cancelled_tax_free":0,"order_name":"테스트 결제","company_name":"주) 부트페이","gateway_url":"https://gw.bootpay.co.kr","metadata":{},"sandbox":true,"pg":"나이스페이먼츠","method":"계좌자동이체","method_symbol":"automatic_transfer_rest","method_origin_symbol":"automatic_transfer_rest","requested_at":"2024-04-18T09:13:54+09:00","status_locale":"자동결제빌링키발급이전","currency":"KRW","status":41}
    #
    #
    #
      res2 = api.publish_automatic_transfer_billing_key(receipt_id: res1.data[:receipt_id])
      print "\n\n" + res2.data.to_json
      # {"receipt_id":"66206779c5aa1f83acf0cd81","subscription_id":"1713399673","gateway_url":"https://gw.bootpay.co.kr","metadata":{},"pg":"나이스페이먼츠","method":"계좌자동이체","method_symbol":"automatic_transfer_rest","method_origin":"계좌자동이체","method_origin_symbol":"automatic_transfer_rest","published_at":"2024-04-18T09:21:14+09:00","requested_at":"2024-04-18", "status_locale":"빌링키발급완료","status":11,"receipt_data":{"receipt_id":"6620677a433dd52127ced6fb","order_id":"1713399673","price":100,"tax_free":0,"cancelled_price":0,"cancelled_tax_free":0,"order_name":"테스트 결제","company_name":"주) 부트페이","gateway_url":"https://gw.bootpay.co.kr","metadata":{},"sandbox":true,"pg":"나이스페이먼츠","method":"계좌이체","m_origin":"계좌자동이체","method_origin_symbol":"automatic_transfer_rest","purchased_at":"2024-04-18T09:21:14+09:00","requested_at":"2024-04-18T09:21:13+09:00","status_locale":"결제완료","currency":"KRW","receipt_url":"https://door.bootpay.co.kr/receipt/a1BibVBkUlF5T2gvTXU5ajVVTndEQXVPclJDZjhBRitsRGs9LS05S040RGV6%0AR24wOVd1dzdPLS1ROTdSZG56TExXMHRhOHl5NTFXOGtRPT0%3D%0A","status":1,"bank_data":{"tid":"4092114073","bank_code":"004","bank_name":"국민","bank_account":"0000000000000000","bank_username":"윤태*"}},"billing_key":"6620677a433dd52127ced6fc","billing_data":{"bank_name":"국민","bank_code":"004","bank_account":"0000000000000000","username":"윤태*"},"billing_expire_at":"2099-12-31T23:59:59+09:00"}

    # res3 = api.request_subscribe_on_continue('66206779c5aa1f83acf0cd81')
    # print res3.data.to_json
    #   {"error_code":"SUBSCRIBE_PUBLISH_NOT_READY","message":"빌링키 발급 대기 상태가 아닙니다."}

    end
  end
end
