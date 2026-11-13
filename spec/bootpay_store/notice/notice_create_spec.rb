# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "notice create" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.notice_create(
        title:      'SDK 테스트 공지',
        content:    'SDK 로 등록한 공지사항입니다.',
        is_notice:  true,
        is_display: true
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
