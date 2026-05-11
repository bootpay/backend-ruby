# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "link payment" do
    puts "link payment"
    api = create_pg_api
    # (legacy) application_id 방식에서만 필요. ck/sk 는 매 요청 Basic Auth 헤더로 직접 인증되므로 호출 불필요.

    if true # api.request_access_token.success?
      response = api.request_link(
        pg:             'nicepay',
        price:          1000,
        tax_free:       1000,
        order_id:       '1234',
        name:           '결제테스트'
      )
      puts response.data.to_json
    end
  end
end
