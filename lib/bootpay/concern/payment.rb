module Bootpay::Concern::Payment
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

    # REST API로 결제 요청하기
    # Comment by Gosomi
    # Date: 2023-03-28
    def request_payment(pg:, method: nil, price:, tax_free: 0, order_name:, order_id:, user_token: nil, uuid: nil, sk: nil,
                        ti: 0, tk: nil, items: [], extra: {}, user: {}, agent: nil)
      rand_uuid = SecureRandom.uuid
      request(
        uri: 'request/payment',
        payload:
             {
               pg:          pg,
               method:      method,
               price:       price,
               tax_free:    tax_free,
               order_name:  order_name,
               order_id:    order_id,
               user_token:  user_token,
               uuid:        uuid.presence || rand_uuid,
               sk:          sk.presence || "#{rand_uuid}-#{Time.current.to_i}",
               ti:          ti,
               tk:          tk.presence || "#{rand_uuid}-#{Time.current.to_i}",
               items:       items,
               extra:       extra,
               user:        user,
               __agent:     agent,
               ver:         Bootpay::RestClient::SDK_VERSION,
               sdk_version: Bootpay::V2_VERSION
             }
      )

    end
  end
end