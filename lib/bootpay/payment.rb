module Bootpay::Payment
  extend ActiveSupport::Concern

  included do
    # 결제 취소 요청
    # Comment by Gosomi
    # Date: 2021-05-21
    def cancel_payment(cancel_id: nil, receipt_id:, cancel_price:, cancel_tax_free: 0, username: '시스템', message: '결제취소',
                       refund: { account: nil, account_holder: nil, bank_code: nil })
      request(
        uri: 'cancel',
        payload:
             {
               cancel_id:       cancel_id.presence || SecureRandom.uuid,
               receipt_id:      receipt_id,
               cancel_price:    cancel_price,
               cancel_tax_free: cancel_tax_free,
               username:        username,
               message:         message,
               refund:          refund
             }.compact
      )
    end
  end
end