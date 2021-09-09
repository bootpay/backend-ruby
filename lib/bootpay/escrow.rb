module Bootpay::Escrow
  extend ActiveSupport::Concern

  included do


    # @deprecated, 사용되지 않는 api
    # Comment by Gosomi
    # Date: 2020-06-18
    # @return [Hash]
    def delivery_start(receipt_id, delivery_no, delivery_corp)
      raise 'receipt_id 값을 설정해주세요.' if receipt_id.blank?
      request(
        mode: :put,
        uri: "delivery/start/#{receipt_id}",
        payload:
          {
            delivery_no:   delivery_no,
            delivery_corp: delivery_corp
          }.compact
      )
    end
  end
end
