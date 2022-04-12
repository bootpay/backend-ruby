module Bootpay::Concern::Sdk
  extend ActiveSupport::Concern

  included do
    # 현재 등록된 지갑 정보를 가져온다
    # Comment by Gosomi
    # Date: 2022-02-21
    def wallets(user_token)
      request(
        method:  :get,
        uri:     "sdk/easy/wallet",
        headers: {
          'Bootpay-User-Token': user_token
        }
      )
    end

    # Biometric Authenticate
    # Comment by Gosomi
    # Date: 2022-02-21
    def regist_biometric_authenticate(os:, token:, user_token:, uuid:)
      request(
        method:  :post,
        uri:     'sdk/easy/biometric',
        headers: {
          'Bootpay-User-Token':  user_token,
          'Bootpay-Device-UUID': uuid
        },
        payload: {
          os:    os,
          token: token
        }
      )
    end
  end
end