module Bootpay::Concern::Payment
  extend ActiveSupport::Concern

  included do
    # 결제 정보 가져오기
    # Comment by Gosomi
    # Date: 2021-12-08
    def receipt_payment(receipt_id, lookup_user_data = false)
      request(
        method: :get,
        uri:    "receipt/#{receipt_id}?lookup_user_data=#{lookup_user_data}",
      )
    end

    # OrderId로 결제 정보 조회하기
    # Comment by GOSOMI
    # @date: 2024-01-27
    def lookup_order_id(order_id)
      request(
        method: :get,
        uri:    "lookup/order/#{order_id}",
      )
    end

    # 결제 승인처리
    # Comment by Gosomi
    # Date: 2022-01-04
    def confirm_payment(receipt_id)
      request(
        uri:     'confirm',
        payload: {
          receipt_id: receipt_id
        }
      )
    end

    # 결제 취소 요청
    # Comment by Gosomi
    # Date: 2021-05-21
    def cancel_payment(cancel_id: nil, receipt_id:, cancel_price: nil, cancel_tax_free: nil, cancel_username: '시스템', cancel_message: '결제취소',
                       cancel_requester: '관리자', refund: { bank_account: nil, bank_username: nil, bank_code: nil }, items: nil)
      request(
        uri: 'cancel',
        payload:
             {
               cancel_id:        cancel_id.presence || SecureRandom.uuid,
               receipt_id:       receipt_id,
               cancel_price:     cancel_price,
               cancel_tax_free:  cancel_tax_free,
               cancel_username:  cancel_username,
               cancel_message:   cancel_message,
               cancel_requester: cancel_requester,
               refund:           refund,
               items:            items
             }.compact
      )
    end

    # REST API로 결제 요청하기
    # Comment by Gosomi
    # Date: 2023-03-28
    def request_payment(platform_application_id:, pg:, method: nil, price:, tax_free: 0, order_name:, order_id:, user_token: nil, uuid: nil, sk: nil,
                        ti: 0, tk: nil, items: [], extra: {}, user: {}, agent: nil)
      rand_uuid = SecureRandom.uuid
      request(
        uri: 'request/payment',
        payload:
             {
               platform_application_id: platform_application_id,
               pg:                      pg,
               method:                  method,
               price:                   price,
               tax_free:                tax_free,
               order_name:              order_name,
               order_id:                order_id,
               user_token:              user_token,
               uuid:                    uuid.presence || rand_uuid,
               sk:                      sk.presence || "#{rand_uuid}-#{Time.current.to_i}",
               ti:                      ti,
               tk:                      tk.presence || "#{rand_uuid}-#{Time.current.to_i}",
               items:                   items,
               extra:                   extra,
               user:                    user,
               __agent:                 agent,
               ver:                     Bootpay::RestClient::SDK_VERSION,
               sdk_version:             Bootpay::V2_VERSION
             }
      )
    end

    # 가상계좌 bulk 발급 요청
    # Comment by GOSOMI
    # @date: 2023-08-08
    def request_virtual_account_bulk(pg:, order_id:, order_name:, currency: 'KRW', price:, tax_free: nil, bank_code:, bank_account:,
                                     bank_username:, cash_receipt_type: nil, identity_no: nil, user: {}, metadata: {}, extra: {})
      request(
        uri: 'request/virtual-account/bulk',
        payload:
             {
               pg:                pg,
               order_id:          order_id,
               order_name:        order_name,
               currency:          currency,
               price:             price,
               tax_free:          tax_free,
               bank_code:         bank_code,
               bank_account:      bank_account,
               bank_username:     bank_username,
               cash_receipt_type: cash_receipt_type,
               identity_no:       identity_no,
               user:              user,
               metadata:          metadata,
               extra:             extra
             }.compact
      )
    end
  end
end