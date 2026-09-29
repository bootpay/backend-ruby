# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "notice update" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.notice_update(
        notice_id:  'NOTICE_ID',
        title:      'SDK 테스트 공지 (수정)',
        is_display: false
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
