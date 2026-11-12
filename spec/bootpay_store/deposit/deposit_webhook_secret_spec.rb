# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "deposit webhook secret" do
    # ⚠️ 부를 때마다 웹훅 비밀값이 바뀐다.
    skip 'BOOTPAY_TEST_DEPOSIT_LIVE=true 일 때만 실행' unless ENV['BOOTPAY_TEST_DEPOSIT_LIVE'] == 'true'

    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.deposit_webhook_secret
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
