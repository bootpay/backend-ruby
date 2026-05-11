# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "cancel payment" do
    puts "cancel payment"
    api = create_pg_api
    # (legacy) application_id 방식에서만 필요. ck/sk 는 매 요청 Basic Auth 헤더로 직접 인증되므로 호출 불필요.

    if true # api.request_access_token.success?
      response = api.cancel_payment(
        receipt_id:      "612df0250d681b001de61de6",
        # cancel_price:    200,
        cancel_username:        'test',
        cancel_message:         'test'
      )
      puts response.data.to_json
    end
  end
end
