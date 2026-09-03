module Bootpay::Concern::Token
  extend ActiveSupport::Concern

  included do
    # Access Token을 요청한다
    # Comment by Gosomi
    # Date: 2021-05-21
    def request_access_token
      response = request(
        uri:     'request/token',
        payload: {
          application_id: @application_id,
          private_key:    @private_key
        }
      )
      @token   = response.data[:access_token] if response.success?
      response
    end

    # client_key/secret_key 를 쓰면 Basic Auth 라 토큰 발급이 필요 없다.
    # 그 경우 요청 없이 성공 응답을 돌려주고, application_id/private_key 면 실제로 토큰을 받는다.
    #
    # ⚠️ 반환 타입은 항상 Bootpay::Response 다. 종전에는 client_key 분기에서 success? 만 정의된
    #    맨 Object 를 돌려줘, 다른 메서드처럼 `.data` 를 부르면 NoMethodError 로 죽었다.
    # Comment by GOSOMI
    # @date: 2026-03-11
    def basic_or_request_access_token
      return Bootpay::Response.new(true, {}) if @use_client_key

      request_access_token
    end
  end
end