module Bootpay::Concern::Authenticate
  extend ActiveSupport::Concern

  included do
    # 본인인증 데이터 가져오기
    # Comment by Gosomi
    # Date: 2021-12-08
    def certificate(receipt_id)
      request(
        method: :get,
        uri:    "certificate/#{receipt_id}"
      )
    end
  end
end