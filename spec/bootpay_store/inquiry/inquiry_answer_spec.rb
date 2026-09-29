# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "inquiry answer" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.inquiry_answer(
        inquiry_id: 'INQUIRY_ID',
        content:    '내일 출고 예정입니다. 감사합니다.'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
