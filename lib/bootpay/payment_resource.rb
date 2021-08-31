
# bootpay dev api
# Comment by Gosomi
# Date: 2020-06-18
# @return [Hash]
module Bootpay::PaymentResource
  extend ActiveSupport::Concern

  included do
    def update_pg_resource(data)
      request(
        uri: 'project/payment',
        payload: data
      )
    end
  end
end
