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

    # 둘다 겸하는 경우 우회함수
    # Comment by GOSOMI
    # @date: 2026-03-11
    def basic_or_request_access_token
      if @use_client_key
        Object.new.tap do |o|
          o.define_singleton_method(:success?) { true }
        end
      else
        request_access_token
      end
    end
  end
end