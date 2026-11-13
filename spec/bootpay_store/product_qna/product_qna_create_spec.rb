# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "product qna create" do
    api   = BootpayStore::RestClient.new(
      client_key: ENV['BP_CLIENT_KEY'],
      secret_key: ENV['BP_SECRET_KEY'],
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.product_qna_create(
        product_id: 'PRODUCT_ID',
        user_id:    'USER_ID',
        title:      '사이즈 문의',
        content:    '평소 M 사이즈를 입는데 어떤 사이즈가 맞을까요?',
        is_secret:  false
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
