# bootpay dev api
# Comment by Gosomi
# Date: 2020-06-18
# @return [Hash]
module Bootpay::PaymentResource
  extend ActiveSupport::Concern

  included do
    def update_pg_resource(data)
      request(
        uri:     'project/payment',
        payload: data
      )
    end

    #----------------------------------------------------------
    # 새로운 웹훅을 실행한다
    # Comment by Gosomi
    # Date: 2021-12-21
    #----------------------------------------------------------
    def create_webhook(receipt_id)
      request(
        uri:     'webhook',
        payload: {
          receipt_id: receipt_id
        }
      )
    end
  end
end
