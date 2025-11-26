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
        name:           '과금 청구서',
        memo:           '과금 청구서입니다',
        user:           {
          user_id: 'gosomi85'
        },
        products:       [
                          {
                            product_id: '68dcee4c5614185fea14a0b7',
                            quantity:   1,
                          }
                        ],
        price:          1000,
        redirect_url:   'https://example.com',
        usage_api_url:  'https://dev-api.bootapi.com/v1/billing/usage',
        use_auto_login: true,
        request_id:     'test1',
        expired_at:     (Time.current + 7.days).strftime('%Y-%m-%d 00:00:00'),
        metadata:       { custom_key: 'custom_value' }
      )
      puts JSON.pretty_generate(response.data)
    end
  end
end