# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "deposit detail" do

    # 키는 환경변수로만 받는다 — 이 리포는 공개된다
    skip 'BP_CLIENT_KEY / BP_SECRET_KEY 환경변수가 필요합니다' if ENV['BP_CLIENT_KEY'].to_s.empty? || ENV['BP_SECRET_KEY'].to_s.empty?

    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.deposit_detail(deposit_id: 'DEPOSIT_ID')
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
