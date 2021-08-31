module Bootpay::Verification
  extend ActiveSupport::Concern

  included do

    # 결제 검증하기
    # Comment by ehowlsla
    # Date: 2021-08-31
    def verify(receipt_id)
      raise 'receipt_id 값을 입력해주세요' if receipt_id.nil?
      request(
        method: :get,
        uri: "receipt/#{receipt_id}"
      )
    end

    # bootpay dev api
    # Comment by ehowlsla
    # Date: 2021-08-31
    def subscribe_verify(receipt_id)
      raise 'receipt_id 값을 입력해주세요' if receipt_id.nil?
      request(
        method: :get,
        uri: "subscribe/billing/#{receipt_id}"
      )
    end

    # 서버 승인하기
    # Comment by ehowlsla
    # Date: 2021-08-31
    def confirm(receipt_id)
      raise 'receipt_id 값을 입력해주세요' if receipt_id.nil?
      request(
        uri: "submit",
        payload: {
          receipt_id: receipt_id
        }.compact
      )
    end

    # 본인인증 검증하기
    # Comment by ehowlsla
    # Date: 2021-08-31
    def certificate(receipt_id)
      raise 'receipt_id 값을 입력해주세요' if receipt_id.nil?
      request(
        method: :get,
        uri: "certificate/#{receipt_id}",
        payload: {
          receipt_id: receipt_id
        }.compact
      )
    end


  end
end