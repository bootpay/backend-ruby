module Bootpay::Concern::Wallet
  extend ActiveSupport::Concern

  included do
    # 등록된 회원의 지갑 정보를 가져온다
    # Comment by GOSOMI
    # @date: 2025-02-13
    def user_wallets(user_id:, widget_key: nil, sandbox: false)
      request(
        uri:    'wallet',
        method: :get,
        params: {
          user_id:    user_id,
          widget_key: widget_key,
          sandbox:    sandbox
        }
      )
    end
  end
end