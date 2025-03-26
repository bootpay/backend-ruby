module BootpayStorage::Concern::Token
  extend ActiveSupport::Concern

  included do
    def set_token(token)
      @token = token
    end
  end
end