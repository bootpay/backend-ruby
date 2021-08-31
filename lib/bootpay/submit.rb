
# Comment by ehowlsla
# Date: 2021-08-31
# @return [Hash]
module Bootpay::Submit
  extend ActiveSupport::Concern

  included do
    def server_submit(receipt_id)
      raise 'receipt_id 값을 입력해주세요.' if receipt_id.blank?

      request(
        uri: 'submit',
        payload: {
          receipt_id: receipt_id
        }
      )
    end
  end
end