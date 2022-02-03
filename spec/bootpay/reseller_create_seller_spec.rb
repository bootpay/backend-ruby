# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "create seller start" do
    api = Bootpay::RestClient.new(
      application_id: '61d4d60b367997009490429d',
      private_key:    'USsMUaEBBb66H+g6r8z5ZZaWECnrldhszGWiNRfVjdU=',
      mode:           'development'
    )
    r   = api.request_access_token
    if r.success?
      response = api.create_seller(
        company_alias: '회사 Alias',
        company_name:  '회사명',
        email:         'gosomi@bootpay.com'
      )
      print response.data.to_json
    else
      print r.data.to_json
    end
  end
end
