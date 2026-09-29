# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "product qna create guest" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.product_qna_create(
        product_id:     'PRODUCT_ID',
        title:          '재입고 문의',
        content:        '품절된 색상 재입고 예정이 있나요?',
        is_secret:      true,
        guest_name:     '비회원',
        guest_password: '1234'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
