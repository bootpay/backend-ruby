# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "product qna update" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.product_qna_update(
        product_qna_id: 'PRODUCT_QNA_ID',
        user_id:        'USER_ID',
        content:        '평소 L 사이즈를 입는데 어떤 사이즈가 맞을까요?'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
