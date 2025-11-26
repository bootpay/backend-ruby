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
                            product_id:        '66fa14954eac568eab4fc2d0',
                            product_option_id: '68ede8c675febc5627363fb2',
                            duration:          24,
                            quantity:          1,
                            price_adjustments: [
                                                 {
                                                   price_adjustment_id: 'test1',
                                                   start_at:            '2025-09-20 00:00:00',
                                                   end_at:              '2025-12-30 23:59:59',
                                                   name:                '첫 구매 할인 프로모션',
                                                   cycles:              [
                                                                          {
                                                                            duration:        1,
                                                                            adjustment_type: 'discount_percent',
                                                                            name:            '첫달 할인',
                                                                            value:           20,
                                                                            min_value:       100,
                                                                            max_value:       500
                                                                          },
                                                                          {
                                                                            duration:        2,
                                                                            adjustment_type: 'discount_price',
                                                                            name:            '둘째달 할인',
                                                                            value:           100
                                                                          },
                                                                          {
                                                                            duration:        1,
                                                                            name:            '도입비',
                                                                            adjustment_type: 'setup_fee',
                                                                            value:           500
                                                                          }
                                                                        ]
                                                 }
                                               ]
                          }
                        ],
        price:          1000,
        redirect_url:   'https://example.com',
        use_auto_login: true,
        request_id:     'test1',
        expired_at:     (Time.current + 7.days).strftime('%Y-%m-%d 00:00:00'),
        metadata:       { custom_key: 'custom_value' },
        extra:          {
          separately_confirmed:     false,
          create_order_immediately: true
        }
      )
      puts JSON.pretty_generate(response.data)
    end
  end
end