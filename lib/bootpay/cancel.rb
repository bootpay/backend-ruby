module Bootpay::Cancel
  extend ActiveSupport::Concern

  included do
    # 결제 취소 요청
    # Comment by Gosomi
    # Date: 2021-05-21
    def cancel_payment(cancel_id: nil, receipt_id:, cancel_price: nil, cancel_tax_free: 0, cancel_username: '시스템', cancel_message: '결제취소',
                       refund: { account: nil, accountholder: nil, bankcode: nil })
      request(
        uri: 'cancel',
        payload:
             {
               cancel_id:       cancel_id.presence || SecureRandom.uuid, # (선택사항) 부분취소 요청시 중복 요청을 방지하기 위한 고유값
               receipt_id:      receipt_id, # 부트페이에서 발급한 영수증 id
               price:           cancel_price, # (선택사항) 부분취소 요청시 금액을 지정, 미지정시 전액 취소 (부분취소가 가능한 PG사, 결제수단에 한해 적용됨)
               tax_free:        cancel_tax_free, # 취소할 비과세 금액
               name:            cancel_username, # 취소 요청자 이름
               reason:          cancel_message, # 취소 요청 사유
               refund:          refund.values.any? {|v|v != nil} ? refund : nil # (선택사항) 가상계좌 환불요청시, 전제조건으로 PG사와 CMS 특약이 체결되어 있을 경우에만 환불요청 가능, 기본적으로 가상계좌는 결제취소가 안됨
             }.compact
      )
    end
  end
end