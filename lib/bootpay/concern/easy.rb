module Bootpay::Concern::CashReceipt
  extend ActiveSupport::Concern

  included do
    # 간편결제 subscribe
    # Comment by Gosomi
    # Date: 2022-02-11
    def subscribe_on_easy(receipt_id:, billing_key:)
      request(
        uri:     'subscribe/easy',
        payload: {
          receipt_id:  receipt_id,
          billing_key: billing_key
        }
      )
    end
  end
end