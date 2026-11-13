# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "inquiry create" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.inquiry_create(
        user_id: 'USER_ID',
        title:   '배송 문의',
        content: '주문한 상품이 언제 출고되나요?'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
