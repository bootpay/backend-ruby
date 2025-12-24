RSpec.describe BootpayStore::RestClient do
  it "invoice request normal product" do
    user_id = 'gosomi85@bootpay.co.kr'
    api     = BootpayStore::RestClient.new(
      client_key: 'QIzXk4M3EeD-6B1GTfmGHA',
      secret_key: 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8=',
      mode:       'development'
    )
    token   = api.request_access_token
    if token.success?
      user_exist = api.id_exist(
        id: 'gosomi85'
      )
      unless user_exist.data[:exist]
        user_create = api.external_user_sign_in(
          uid:            user_id,
          name:           '테스트 사용자',
          email:          user_id,
          login_id:       'gosomi85',
          login_email:    user_id,
          phone:          '010000000000',
          is_group_admin: true,
        )
        puts user_create.data
      end
      response   = api.create_invoice(
        name:             '테스트 청구서',
        memo:             '테스트 청구서 상세 메모',
        user:             {
          membership_type: 'guest',
          name:            '부트페이',
          user_id:         'test123',
          phone:           '01095735114'
        },
        products:         [
                            {
                              product_id:        '66fa14954eac568eab4fc2d0',
                              product_option_id: '68ede8c675febc5627363fb2',
                              duration:          24,
                              quantity:          1,
                            }
                          ],
        price:            1000,
        redirect_url:     'https://example.com',
        use_auto_login:   true,
        request_id:       'test1',
        use_notification: true,
        expired_at:       (Time.current + 7.days).strftime('%Y-%m-%d 00:00:00'),
        metadata:         { custom_key: 'custom_value' }
      )
      puts JSON.pretty_generate(response.data)
    end
  end
end