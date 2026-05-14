module Bootpay::Authentication
  extend ActiveSupport::Concern

  included do
    # 본인인증 요청 (SMS / PASS)
    # NodeJS: POST request/authentication
    def request_authentication(authentication_id: nil, pg: nil, method: nil, username: nil,
                                identity_no: nil, carrier: nil, phone: nil, client_ip: nil,
                                order_name: nil, site_url: nil, authenticate_type: nil,
                                extra: nil, user: nil, metadata: nil)
      raise 'authentication_id 값을 입력해주세요.' if authentication_id.blank?
      raise 'pg 값을 입력해주세요.'                if pg.blank?
      raise 'method 값을 입력해주세요.'            if method.blank?
      raise 'username 값을 입력해주세요.'          if username.blank?
      raise 'identity_no 값을 입력해주세요.'       if identity_no.blank?
      raise 'carrier 값을 입력해주세요.'           if carrier.blank?
      raise 'phone 값을 입력해주세요.'             if phone.blank?
      raise 'client_ip 값을 입력해주세요.'         if client_ip.blank?
      raise 'order_name 값을 입력해주세요.'        if order_name.blank?
      request(
        uri:     'request/authentication',
        payload: {
          authentication_id: authentication_id,
          pg:                pg,
          method:            method,
          username:          username,
          identity_no:       identity_no,
          carrier:           carrier,
          phone:             phone,
          client_ip:         client_ip,
          order_name:        order_name,
          site_url:          site_url,
          authenticate_type: authenticate_type,
          extra:             extra,
          user:              user,
          metadata:          metadata
        }.compact
      )
    end

    # 본인인증 확인 (OTP 입력)
    # NodeJS: POST authenticate/confirm
    def confirm_authentication(receipt_id, otp: nil)
      raise 'receipt_id 값을 입력해주세요.' if receipt_id.blank?
      request(
        uri:     'authenticate/confirm',
        payload: { receipt_id: receipt_id, otp: otp }.compact
      )
    end

    # 본인인증 SMS 재발송
    # NodeJS: POST authenticate/realarm
    def realarm_authentication(receipt_id)
      raise 'receipt_id 값을 입력해주세요.' if receipt_id.blank?
      request(
        uri:     'authenticate/realarm',
        payload: { receipt_id: receipt_id }
      )
    end
  end
end
