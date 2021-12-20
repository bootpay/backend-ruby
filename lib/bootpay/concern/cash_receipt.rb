module Bootpay::Concern::CashReceipt
  extend ActiveSupport::Concern

  included do
    # 현금 영수증 발행 처리 하기
    # Comment by Gosomi
    # Date: 2021-12-15
    def request_cash_receipt(pg:, item_name:, identity_no:, purchased_at:, cash_receipt_type:, price:, tax_free:, user: {},
                             user_params: {}, extra: {}, order_id:)
      request(
        method:  :post,
        uri:     'request/cash/receipt',
        payload: {
          pg:                pg,
          item_name:         item_name,
          identity_no:       identity_no,
          purchased_at:      purchased_at,
          cash_receipt_type: cash_receipt_type,
          price:             price,
          tax_free:          tax_free,
          user:              user,
          user_params:       user_params,
          order_id:          order_id,
          extra:             extra
        }
      )
    end

    # 현금영수증 발행 취소
    # Comment by Gosomi
    # Date: 2021-12-16
    def cancel_cash_receipt(receipt_id:, cancel_username:, cancel_message:)
      request(
        method:  :delete,
        uri:     "request/cash/receipt/#{receipt_id}",
        headers: {
          params: {
            cancel_username: cancel_username,
            cancel_message:  cancel_message
          }
        }
      )
    end
  end
end