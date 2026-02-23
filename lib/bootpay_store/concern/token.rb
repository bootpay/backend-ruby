module BootpayStore::Concern::Token
  extend ActiveSupport::Concern

  included do
    # Access Token을 요청한다
    # Comment by Gosomi
    # Date: 2021-05-21
    # @deprecated
    def request_access_token
      response = request(
        uri:     'request/token',
        headers: {
          Authorization: "Basic #{Base64.strict_encode64("#{@client_key}:#{@secret_key}")}"
        }
      )
      @token   = response.data[:access_token] if response.success?
      response
    end

    def set_token(token)
      @token = token
    end
  end
end