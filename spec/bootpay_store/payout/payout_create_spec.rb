# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "payout create" do
    # ⚠️ 지급 원장에 등록되고 배치가 실제로 송금한다.
    skip 'BOOTPAY_TEST_PAYOUT_LIVE=true 일 때만 실행' unless ENV['BOOTPAY_TEST_PAYOUT_LIVE'] == 'true'

    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.payout_create(sub_seller_id: 'SUB_SELLER_ID', amount: 1000, merchant_payout_id: "sdk-test-#{Time.now.to_i}")
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
