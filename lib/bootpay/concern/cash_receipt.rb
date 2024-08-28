module Bootpay::Concern::CashReceipt
  extend ActiveSupport::Concern

  included do
    # 현금 영수증 발행 처리 하기
    # Comment by Gosomi
    # Date: 2021-12-15
    def request_cash_receipt(pg:, order_name:, identity_no:, purchased_at:, cash_receipt_type:, price:, tax_free:, user: {},
                             metadata: {}, extra: {}, order_id:)
      request(
        method:  :post,
        uri:     'request/cash/receipt',
        payload: {
          pg:                pg,
          order_name:        order_name,
          identity_no:       identity_no,
          purchased_at:      purchased_at,
          cash_receipt_type: cash_receipt_type,
          price:             price,
          tax_free:          tax_free,
          user:              user,
          metadata:          metadata,
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

    # 결제된 계좌이체/가상계좌 결제건중 누락된 현금영수증을 발행해주는 API
    # Comment by Gosomi
    # Date: 2022-07-21
    def cash_receipt_publish_on_receipt(receipt_id:, username:, email:, phone:, identity_no:, currency: 'WON',
                                        cash_receipt_type: '소득공제', pg: nil, test_production: false)
      request(
        method:  :post,
        uri:     "request/receipt/cash/publish",
        payload: {
          pg:                pg,
          receipt_id:        receipt_id,
          username:          username,
          email:             email,
          phone:             phone,
          identity_no:       identity_no,
          currency:          currency,
          cash_receipt_type: cash_receipt_type,
          test_production:   test_production
        }
      )
    end

    # 결제에 포함된 현금영수증 취소
    # Comment by Gosomi
    # Date: 2022-07-21
    def cash_receipt_cancel_on_receipt(receipt_id:, cancel_username:, cancel_message:)
      request(
        method:  :delete,
        uri:     "request/receipt/cash/cancel/#{receipt_id}",
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