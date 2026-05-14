module Bootpay::CashReceipt
  extend ActiveSupport::Concern

  included do
    # 결제 건에 현금영수증 발급 요청
    # NodeJS: POST request/receipt/cash/publish
    def cash_receipt_publish_on_receipt(receipt_id: nil, identity_no: nil,
                                         cash_receipt_type: nil, username: nil,
                                         email: nil, phone: nil, currency: nil)
      raise 'receipt_id 값을 입력해주세요.'        if receipt_id.blank?
      raise 'identity_no 값을 입력해주세요.'       if identity_no.blank?
      raise 'cash_receipt_type 값을 입력해주세요.' if cash_receipt_type.blank?
      request(
        uri:     'request/receipt/cash/publish',
        payload: {
          receipt_id:        receipt_id,
          identity_no:       identity_no,
          cash_receipt_type: cash_receipt_type, # 소득공제 | 지출증빙
          username:          username,
          email:             email,
          phone:             phone,
          currency:          currency
        }.compact
      )
    end

    # 결제 건에 발급된 현금영수증 취소
    # NodeJS: DELETE request/receipt/cash/cancel/{receiptId}
    def cash_receipt_cancel_on_receipt(receipt_id, cancel_username: nil, cancel_message: nil)
      raise 'receipt_id 값을 입력해주세요.' if receipt_id.blank?
      request(
        method:  :delete,
        uri:     "request/receipt/cash/cancel/#{receipt_id}",
        params:  { cancel_username: cancel_username, cancel_message: cancel_message }.compact
      )
    end

    # 단독 현금영수증 발급
    # NodeJS: POST request/cash/receipt
    def request_cash_receipt(pg: nil, price: nil, order_name: nil, cash_receipt_type: nil,
                              identity_no: nil, order_id: nil, tax_free: nil,
                              purchased_at: nil, user: nil, extra: nil)
      raise 'pg 값을 입력해주세요.'                if pg.blank?
      raise 'price 값을 입력해주세요.'             if price.blank?
      raise 'order_name 값을 입력해주세요.'        if order_name.blank?
      raise 'cash_receipt_type 값을 입력해주세요.' if cash_receipt_type.blank?
      raise 'identity_no 값을 입력해주세요.'       if identity_no.blank?
      raise 'order_id 값을 입력해주세요.'          if order_id.blank?
      request(
        uri:     'request/cash/receipt',
        payload: {
          pg:                pg,
          price:             price,
          order_name:        order_name,
          cash_receipt_type: cash_receipt_type,
          identity_no:       identity_no,
          order_id:          order_id,
          tax_free:          tax_free,
          purchased_at:      purchased_at,
          user:              user,
          extra:             extra
        }.compact
      )
    end

    # 단독 현금영수증 취소
    # NodeJS: DELETE request/cash/receipt/{receiptId}
    def cancel_cash_receipt(receipt_id, cancel_username: nil, cancel_message: nil)
      raise 'receipt_id 값을 입력해주세요.' if receipt_id.blank?
      request(
        method:  :delete,
        uri:     "request/cash/receipt/#{receipt_id}",
        params:  { cancel_username: cancel_username, cancel_message: cancel_message }.compact
      )
    end
  end
end
