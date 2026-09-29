# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "inquiry update" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.inquiry_update(
        inquiry_id: 'INQUIRY_ID',
        user_id:    'USER_ID',
        content:    '주문한 상품의 출고일을 알려주세요.'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
