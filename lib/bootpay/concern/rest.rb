module Bootpay::Concern::Rest
  extend ActiveSupport::Concern

  included do
    private

    # HTTP Request 기본 Method
    # Comment by Gosomi
    # Date: 2021-05-21
    def request(method: :post, uri:, payload: {}, headers: {})
      response = HTTP.headers(
        {
          Authorization: "Bearer #{@token}",
          content_type:  'application/json',
          accept:        'application/json'
        }.merge!(headers).compact
      ).send(
        method.to_sym,
        [Bootpay::RestClient::API[@mode.to_sym], uri].join('/'),
        json: payload
      )
      Bootpay::Response.new(
        response.status.success?,
        JSON.parse(response.body.to_s, symbolize_names: true)
      )
    rescue Exception => e
      Bootpay::Response.new(
        false,
        message:   "부트페이 API 서버와의 통신이 실패하였습니다. 오류 메세지: #{e.message}",
        backtrace: e.backtrace.join("\n")
      )
    end
  end
end