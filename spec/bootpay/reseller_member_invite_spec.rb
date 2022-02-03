# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "member invite" do
    api = Bootpay::RestClient.new(
      application_id: '61d4d60b367997009490429d',
      private_key:    'USsMUaEBBb66H+g6r8z5ZZaWECnrldhszGWiNRfVjdU=',
      mode:           'development'
    )
    r   = api.request_access_token
    if r.success?
      # response = api.member_invite(
      #   email:       'aqure84@naver.com',
      #   app_id:      '61dfbccf1fc192039249ca6b',
      #   level:       '관리자',
      #   invite_type: '프로젝트'
      # )
      response = api.member_invite(
        email:       'gosomi@bootpay.co.kr',
        provider_id: '61d7828e1fc19202e52d1865',
        level:       '관리자',
        invite_type: '팀'
      )
      print response.data.to_json
    else
      print r.data.to_json
    end
  end
end
