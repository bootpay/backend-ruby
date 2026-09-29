# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "product qna answer" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.product_qna_answer(
        product_qna_id: 'PRODUCT_QNA_ID',
        content:        '정사이즈로 M 을 추천드립니다.'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
