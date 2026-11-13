# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "faq create" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.faq_create(
        title:      '배송은 얼마나 걸리나요?',
        content:    '결제 후 영업일 기준 2~3일 내 도착합니다.',
        is_display: true
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
