# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "product qna detail" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.product_qna_detail(
        product_qna_id: 'PRODUCT_QNA_ID',
        user_id:        'USER_ID'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
