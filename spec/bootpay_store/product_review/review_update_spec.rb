# frozen_string_literal: true

RSpec.describe BootpayStore::RestClient do
  it "review update" do
    api   = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: '***REMOVED***',
      mode:       'development'
    )
    token = api.request_access_token
    if token.success?
      response = api.review_update(
        product_review_id: 'PRODUCT_REVIEW_ID',
        user_id:           'USER_ID',
        rating:            4,
        content:           '한 달 써보니 조금 늘어나지만 만족합니다.'
      )
      puts JSON.pretty_generate(response.data)
    else
      puts token.data
    end
  end
end
