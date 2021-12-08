module Bootpay::Payment
  extend ActiveSupport::Concern

  included do
    # 결제 정보 가져오기
    # Comment by Gosomi
    # Date: 2021-12-08
    def receipt_payment(receipt_id)
      request(
        method: :get,
        uri:    "receipt/#{receipt_id}"
      )
    end

    # 결제 취소 요청
    # Comment by Gosomi
    # Date: 2021-05-21
    def cancel_payment(cancel_id: nil, receipt_id:, cancel_price: nil, cancel_tax_free: 0, cancel_username: '시스템', cancel_message: '결제취소',
                       refund: { bank_account: nil, bank_username: nil, bank_code: nil }, items: nil)
      request(
        uri: 'cancel',
        payload:
             {
               cancel_id:       cancel_id.presence || SecureRandom.uuid,
               receipt_id:      receipt_id,
               cancel_price:    cancel_price,
               cancel_tax_free: cancel_tax_free,
               cancel_username: cancel_username,
               cancel_message:  cancel_message,
               refund:          refund,
               items:           items
             }.compact
      )
    end
  end
end