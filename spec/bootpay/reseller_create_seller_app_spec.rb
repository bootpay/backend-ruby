# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "create seller app" do
    api = Bootpay::RestClient.new(
      application_id: '61d4d60b367997009490429d',
      private_key:    'USsMUaEBBb66H+g6r8z5ZZaWECnrldhszGWiNRfVjdU=',
      mode:           'development'
    )
    r   = api.request_access_token
    if r.success?
      response = api.create_seller_app(
        provider_id: '61d7828e1fc19202e52d1865',
        name:    '생성된 봇 앱2'
      )
      print response.data.to_json
    else
      print r.data.to_json
    end
  end
end
