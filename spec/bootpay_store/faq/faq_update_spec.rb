# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "faq update" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.faq_update(
        faq_id:  'FAQ_ID',
        content: '결제 후 영업일 기준 1~2일 내 도착합니다.'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
