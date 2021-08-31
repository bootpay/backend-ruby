module Bootpay::Cancel
  extend ActiveSupport::Concern

  included do
    # 결제 취소 요청
    # Comment by Gosomi
    # Date: 2021-05-21
    def cancel_payment(cancel_id: nil, receipt_id:, cancel_price: nil, cancel_tax_free: 0, cancel_username: '시스템', cancel_message: '결제취소',
                       refund: { bank_account: nil, bank_username: nil, bank_code: nil })
      request(
        uri: 'cancel',
        payload:
             {
               cancel_id:       cancel_id.presence || SecureRandom.uuid,
               receipt_id:      receipt_id,
               price:           cancel_price,
               tax_free:        cancel_tax_free,
               name:            cancel_username,
               reason:          cancel_message,
               refund:          refund[:bank_account].presence || nil
             }.compact
      )
    end
  end
end