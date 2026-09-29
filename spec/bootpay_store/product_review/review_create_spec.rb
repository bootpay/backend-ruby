# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "review create" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.review_create(
        user_id:    'USER_ID',
        order_id:   'ORDER_ID',
        product_id: 'PRODUCT_ID',
        rating:     5,
        content:    '배송도 빠르고 품질도 좋아요. 재구매 의사 있습니다.',
        images:     ['https://example.com/review-1.jpg']
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
