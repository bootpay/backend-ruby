module Bootpay::Wallet
  extend ActiveSupport::Concern

  included do
    # 사용자 월렛 목록 조회
    # Reference: Go SDK GetUserWallets
    #
    # @deprecated 다음 메이저 버전에서 제거 예정. wallet 엔드포인트는 폐기 예정이며,
    #   결제는 Request::PaymentController#create 의 wallet_id + user_token 으로 처리됩니다.
    def get_user_wallets(user_id:, sandbox: false)
      warn '[DEPRECATION] `get_user_wallets` is deprecated and will be removed in a future major version.'
      raise 'user_id 값을 입력해주세요.' if user_id.blank?

      request(
        method: :get,
        uri: "wallet?user_id=#{user_id}&sandbox=#{sandbox}"
      )
    end

    # 월렛 결제 요청
    # Reference: Go SDK RequestWalletPayment
    #
    # @deprecated 다음 메이저 버전에서 제거 예정. wallet 엔드포인트는 폐기 예정이며,
    #   결제는 wallet_id + user_token 흐름으로 전환하세요.
    def request_wallet_payment(user_id:, order_name:, price:, order_id:, tax_free: 0, sandbox: false,
                               webhook_url: nil, content_type: nil,
                               items: nil,
                               user_info: nil,
                               extra: nil,
                               metadata: nil)
      warn '[DEPRECATION] `request_wallet_payment` is deprecated and will be removed in a future major version.'
      raise 'user_id 값을 입력해주세요.' if user_id.blank?
      raise 'order_name 값을 입력해주세요.' if order_name.blank?
      raise 'price 금액을 설정해주세요.' if price.blank?
      raise 'order_id 주문번호를 설정해주세요.' if order_id.blank?

      request(
        uri: 'wallet/payment',
        payload: {
          user_id:      user_id,
          order_name:   order_name,
          price:        price,
          tax_free:     tax_free,
          order_id:     order_id,
          sandbox:      sandbox,
          webhook_url:  webhook_url,
          content_type: content_type,
          items:        items,
          user:         user_info,
          extra:        extra,
          metadata:     metadata
        }.compact
      )
    end
  end
end
