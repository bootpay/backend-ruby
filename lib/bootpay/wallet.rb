module Bootpay::Wallet
  extend ActiveSupport::Concern

  included do
    # 사용자 월렛 목록 조회
    # Reference: Go SDK GetUserWallets
    def get_user_wallets(user_id:, sandbox: false)
      raise 'user_id 값을 입력해주세요.' if user_id.blank?

      request(
        method: :get,
        uri: "wallet?user_id=#{user_id}&sandbox=#{sandbox}"
      )
    end

    # 월렛 결제 요청
    # Reference: Go SDK RequestWalletPayment
    def request_wallet_payment(user_id:, order_name:, price:, order_id:, tax_free: 0, sandbox: false,
                               webhook_url: nil, content_type: nil,
                               items: nil,
                               user_info: nil,
                               extra: nil,
                               metadata: nil)
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
