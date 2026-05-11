# frozen_string_literal: true

RSpec.describe "PG API - Wallet", :integration do
  let(:api) do
    api = create_pg_api
    # (legacy) application_id 방식에서만 필요. ck/sk 는 매 요청 Basic Auth 헤더로 직접 인증되므로 호출 불필요.
    api.request_access_token if ENV['BOOTPAY_AUTH_MODE'].to_s.downcase == 'legacy'
    api
  end

  it "gets user wallets" do
    response = api.get_user_wallets(
      user_id: 'test_user_1234',
      sandbox: true
    )

    puts "=== Get User Wallets Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end

  it "requests a wallet payment" do
    response = api.request_wallet_payment(
      user_id:    'test_user_1234',
      order_name: '테스트 월렛 결제',
      price:      1000,
      order_id:   "test_wallet_#{Time.now.to_i}",
      tax_free:   0,
      sandbox:    true
    )

    puts "=== Wallet Payment Response ==="
    puts response.data.to_json

    expect(response).not_to be_nil
    expect(response.data).not_to be_nil
  end
end
