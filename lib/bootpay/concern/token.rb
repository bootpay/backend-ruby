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
  end
end