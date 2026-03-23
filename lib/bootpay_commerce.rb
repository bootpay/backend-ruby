# frozen_string_literal: true

require_relative 'bootpay/commerce/commerce_resource'
require_relative 'bootpay/commerce/user'
require_relative 'bootpay/commerce/user_group'
require_relative 'bootpay/commerce/product'
require_relative 'bootpay/commerce/invoice'
require_relative 'bootpay/commerce/order'
require_relative 'bootpay/commerce/order_cancel'
require_relative 'bootpay/commerce/order_subscription'
require_relative 'bootpay/commerce/order_subscription_bill'
require_relative 'bootpay/commerce/order_subscription_adjustment'
require_relative 'bootpay/commerce/store'

module Bootpay
  module Commerce
    # Bootpay Commerce API 클라이언트
    #
    # 사용 예시:
    #   commerce = Bootpay::Commerce::Api.new(
    #     client_key: 'your_client_key',
    #     secret_key: 'your_secret_key',
    #     mode: 'production'
    #   )
    #
    #   # 액세스 토큰 발급
    #   token_response = commerce.get_access_token
    #
    #   # Role 설정 (메서드 체이닝 지원)
    #   commerce.as_manager
    #
    #   # 사용자 목록 조회
    #   users = commerce.user.list(page: 1, limit: 10)
    #
    #   # 상품 생성 (이미지 포함)
    #   product = commerce.product.create({ name: '상품명', price: 10000 }, ['/path/to/image.jpg'])
    #
    class Api < CommerceResource
      attr_reader :user, :user_group, :product, :invoice, :order,
                  :order_cancel, :order_subscription, :order_subscription_bill,
                  :order_subscription_adjustment, :store

      def initialize(client_key: nil, secret_key: nil, mode: 'production')
        super()
        if client_key && secret_key
          set_configuration(client_key: client_key, secret_key: secret_key, mode: mode)
        end
        init_modules
      end

      # 액세스 토큰 발급
      # client_key/secret_key로 Basic Auth 인증
      def get_access_token
        response = post_with_basic_auth('request/token', {
          client_key: @client_key,
          secret_key: @secret_key
        })

        if response.is_a?(Hash) && response[:access_token]
          set_token(response[:access_token])
        end

        response
      end

      # 토큰을 발급받아 설정 (메서드 체이닝)
      def with_token
        get_access_token
        self
      end

      # 현재 설정된 토큰 반환
      def current_token
        get_token
      end

      # 토큰이 설정되어 있는지 확인
      def has_token?
        token = get_token
        !token.nil? && !token.empty?
      end

      # Role 설정 (메서드 체이닝)
      def with_role(role)
        set_role(role)
        self
      end

      # 일반 사용자 role로 설정
      def as_user
        with_role('user')
      end

      # 매니저 role로 설정
      def as_manager
        with_role('manager')
      end

      # 파트너 role로 설정
      def as_partner
        with_role('partner')
      end

      # 벤더 role로 설정
      def as_vendor
        with_role('vendor')
      end

      # 슈퍼바이저 role로 설정
      def as_supervisor
        with_role('supervisor')
      end

      # 현재 role 반환
      def current_role
        get_role
      end

      # role을 기본값(user)으로 초기화
      def clear_role
        set_role('user')
        self
      end

      private

      def init_modules
        @user                            = UserModule.new(self)
        @user_group                      = UserGroupModule.new(self)
        @product                         = ProductModule.new(self)
        @invoice                         = InvoiceModule.new(self)
        @order                           = OrderModule.new(self)
        @order_cancel                    = OrderCancelModule.new(self)
        @order_subscription              = OrderSubscriptionModule.new(self)
        @order_subscription_bill         = OrderSubscriptionBillModule.new(self)
        @order_subscription_adjustment   = OrderSubscriptionAdjustmentModule.new(self)
        @store                           = StoreModule.new(self)
      end
    end
  end
end
