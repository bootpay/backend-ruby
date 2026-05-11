# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "easy payment" do
    puts "easy payment"
    api = create_pg_api
    # (legacy) application_id 방식에서만 필요. ck/sk 는 매 요청 Basic Auth 헤더로 직접 인증되므로 호출 불필요.

    if true # api.request_access_token.success?
      response = api.get_user_token(
        user_id: '1234',
        email: 'test@gmail.com',
        name: '테스트',
      )
      puts response.data.to_json
    end
  end
end
