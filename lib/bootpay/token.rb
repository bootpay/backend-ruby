module Bootpay::Token
  extend ActiveSupport::Concern

  included do
    # Access Token을 요청한다
    # Comment by Gosomi
    # Date: 2021-05-21
    def request_access_token
      # client_key/secret_key 인증은 매 요청에 Basic Auth 헤더가 자동 부착된다.
      # request/token 호출이 불필요하므로 합성 응답을 즉시 반환한다.
      if @client_key.present? && @secret_key.present?
        @token = nil
        return Bootpay::Response.new(true, { access_token: '', expire_in: 0 })
      end

      response = request(
        uri:     'request/token',
        payload: {
          application_id: @application_id,
          private_key:    @private_key
        }
      )
      if response.success?
        # 기존 Ruby PG 응답(data.token)을 우선 유지하되, 다른 SDK/신규 응답(access_token)도
        # 받을 수 있게 확장한다. 기존 응답 구조와 token 값에는 영향을 주지 않는다.
        @token = response.data.dig(:data, :token)
        @token ||= response.data[:access_token]
        @token ||= response.data.dig(:data, :access_token)
      end
      response
    end
  end
end
