# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "submit" do
    puts "submit"
    receipt_id = '612e09260d681b0021e61ab9'

    api = create_pg_api
    # (legacy) application_id 방식에서만 필요. ck/sk 는 매 요청 Basic Auth 헤더로 직접 인증되므로 호출 불필요.

    if true # api.request_access_token.success?
      response = api.server_submit(receipt_id)
      print  response.data.to_json
    end
  end 
end
