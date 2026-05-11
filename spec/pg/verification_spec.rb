# frozen_string_literal: true

RSpec.describe Bootpay::Api do
  it "verification" do
    puts "verification"
    receipt_id = '612df0250d681b001de61de6'

    api = create_pg_api
    # (legacy) application_id 방식에서만 필요. ck/sk 는 매 요청 Basic Auth 헤더로 직접 인증되므로 호출 불필요.

    if true # api.request_access_token.success?
      response = api.verify(receipt_id)
      puts  response.data.to_json
    end
  end

  it 'certificate' do
    puts "certificate"
    receipt_id = '612df0250d681b001de61de6'
  
    api = create_pg_api
    # (legacy) application_id 방식에서만 필요. ck/sk 는 매 요청 Basic Auth 헤더로 직접 인증되므로 호출 불필요.

    if true # api.request_access_token.success?
      response = api.certificate(receipt_id)
      puts  response.data.to_json
    end
  end
end
