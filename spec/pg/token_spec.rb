# frozen_string_literal: true

RSpec.describe "PG API - Token", :integration do
  it "ck/sk 모드: HTTP 호출 없이 합성 응답 (access_token: '', expire_in: 0) 반환" do
    # BOOTPAY_AUTH_MODE 토글과 무관하게 ck/sk 동작을 검증해야 하므로 create_pg_api_ck 직접 호출.
    api = create_pg_api_ck
    response = api.request_access_token

    puts "=== PG Token Response (ck/sk) ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.success?).to eq(true)
    expect(response.data[:access_token]).to eq('')
    expect(response.data[:expire_in]).to eq(0)
    expect(api.instance_variable_get(:@token)).to be_nil
  end

  it "legacy application_id/private_key 모드: 실제 access_token 발급" do
    api = create_pg_legacy_api
    response = api.request_access_token

    puts "=== PG Token Response (legacy) ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.success?).to eq(true)

    issued_token = response.data[:access_token] ||
                   response.data.dig(:data, :access_token) ||
                   response.data.dig(:data, :token)
    expect(issued_token).to be_a(String)
    expect(issued_token).not_to be_empty
    expect(api.instance_variable_get(:@token)).to eq(issued_token)
  end
end
