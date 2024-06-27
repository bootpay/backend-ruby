module Bootpay::Concern::Service
  extend ActiveSupport::Concern

  included do
    # 등록된 Wallet 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2024-06-27
    def lookup_service_wallets
      request(
        uri:    'seller/service/wallet',
        method: :get
      )
    end
  end
end