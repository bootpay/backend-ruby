# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "deposit cancel" do
    # ⚠️ 실제 입금대기 주문이 닫힌다.
    skip 'BOOTPAY_TEST_DEPOSIT_LIVE=true 일 때만 실행' unless ENV['BOOTPAY_TEST_DEPOSIT_LIVE'] == 'true'

    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.deposit_cancel(deposit_id: 'DEPOSIT_ID')
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
