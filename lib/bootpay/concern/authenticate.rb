module Bootpay::Concern::Authenticate
  extend ActiveSupport::Concern

  included do
    # 본인인증 데이터 가져오기
    # Comment by Gosomi
    # Date: 2021-12-08
    def certificate(receipt_id)
      request(
        method: :get,
        uri:    "certificate/#{receipt_id}"
      )
    end

    # REST API로 본인인증 요청하기
    # Comment by Gosomi
    # Date: 2022-11-02
    def request_authentication(pg:, method:, username:, identity_no:, carrier:, phone:, site_url:,
                               authenticate_type: 'sms', order_name: '', authentication_id: '', extra: {}, user: {})
      request(
        method:  :post,
        uri:     'request/authentication',
        payload: {
          pg:                pg,
          method:            method,
          username:          username,
          identity_no:       identity_no,
          carrier:           carrier,
          phone:             phone,
          site_url:          site_url,
          authenticate_type: authenticate_type,
          order_name:        order_name,
          authentication_id: authentication_id,
          extra:             extra,
          user:              user
        }
      )
    end

    # 본인인증 승인결과를 가져온다
    # Comment by Gosomi
    # Date: 2022-11-03
    def confirm_authentication(receipt_id:, otp: nil)
      request(
        method:  :post,
        uri:     'authenticate/confirm',
        payload: {
          receipt_id: receipt_id,
          otp:        otp
        }
      )
    end

    # 다시 SMS/알람 보내기
    # Comment by Gosomi
    # Date: 2022-11-03
    def realarm_authentication(receipt_id)
      request(
        method:  :post,
        uri:     'authenticate/realarm',
        payload: {
          receipt_id: receipt_id
        }
      )
    end
  end
end