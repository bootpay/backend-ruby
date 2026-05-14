module Bootpay::AutomaticTransfer
  extend ActiveSupport::Concern

  included do
    # 자동이체 빌링키 발급 요청
    # NodeJS: POST request/subscribe/automatic-transfer
    def request_subscribe_automatic_transfer_billing_key(
      pg: nil, order_name: nil, subscription_id: nil,
      auth_type: nil, username: nil, bank_name: nil, bank_account: nil, identity_no: nil,
      method: nil, cash_receipt_type: nil, cash_receipt_identity_no: nil,
      phone: nil, price: nil, tax_free: nil,
      extra: nil, user: nil, metadata: nil
    )
      raise 'pg 값을 입력해주세요.'              if pg.blank?
      raise 'order_name 값을 입력해주세요.'      if order_name.blank?
      raise 'subscription_id 값을 입력해주세요.' if subscription_id.blank?
      raise 'auth_type 값을 입력해주세요.'       if auth_type.blank?
      raise 'username 값을 입력해주세요.'        if username.blank?
      raise 'bank_name 값을 입력해주세요.'       if bank_name.blank?
      raise 'bank_account 값을 입력해주세요.'    if bank_account.blank?
      raise 'identity_no 값을 입력해주세요.'     if identity_no.blank?
      request(
        uri:     'request/subscribe/automatic-transfer',
        payload: {
          pg:                       pg,
          order_name:               order_name,
          subscription_id:          subscription_id,
          auth_type:                auth_type, # ARS | 간편인증
          username:                 username,
          bank_name:                bank_name,
          bank_account:             bank_account,
          identity_no:              identity_no,
          method:                   method,
          cash_receipt_type:        cash_receipt_type, # 소득공제 | 지출증빙
          cash_receipt_identity_no: cash_receipt_identity_no,
          phone:                    phone,
          price:                    price,
          tax_free:                 tax_free,
          extra:                    extra,
          user:                     user,
          metadata:                 metadata
        }.compact
      )
    end

    # 자동이체 빌링키 발급 완료
    # NodeJS: POST request/subscribe/automatic-transfer/publish
    def publish_automatic_transfer_billing_key(receipt_id)
      raise 'receipt_id 값을 입력해주세요.' if receipt_id.blank?
      request(
        uri:     'request/subscribe/automatic-transfer/publish',
        payload: { receipt_id: receipt_id }
      )
    end
  end
end
