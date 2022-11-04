# frozen_string_literal: true

RSpec.describe Bootpay::RestClient do
  it "request authentication" do
    api = Bootpay::RestClient.new(
      application_id: '59bfc738e13f337dbd6ca48a',
      private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0=',
      mode:           'development'
    )
    # api = Bootpay::RestClient.new(
    #   application_id: '62d60a39e38c3000235afe63',
    #   private_key:    'Nuu09hRbQ+8EmEfLEu1HeaLwsZd38BJmtwhLa1pxI24=',
    #   mode:           'stage'
    # )
    if api.request_access_token.success?
      response = api.request_authentication(
        pg:                '다날',
        method:            '본인인증',
        username:          '강훈',
        identity_no:       '8410251',
        carrier:           'SKT',
        phone:             '01095735114',
        site_url:          'https://www.bootpay.co.kr',
        order_name:        '본인인증하기 ',
        authentication_id: Time.now.to_i.to_s,
        authenticate_type: 'sms'
      )
      print response.data.to_json
    end
  end
end
