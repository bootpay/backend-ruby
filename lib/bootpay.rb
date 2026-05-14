require 'active_support/all'
require 'base64'
require 'http'
require_relative 'response'
require_relative 'bootpay/authentication'
require_relative 'bootpay/automatic_transfer'
require_relative 'bootpay/billing'
require_relative 'bootpay/cancel'
require_relative 'bootpay/cash_receipt'
require_relative 'bootpay/easy'
require_relative 'bootpay/escrow'
require_relative 'bootpay/link'
require_relative 'bootpay/naverpay'
require_relative 'bootpay/payment_resource'
require_relative 'bootpay/reseller'
require_relative 'bootpay/rest'
require_relative 'bootpay/submit'
require_relative 'bootpay/token'
require_relative 'bootpay/verification'
require_relative "bootpay/version"
require_relative 'bootpay/wallet'

module Bootpay
  class Api
    include Authentication
    include AutomaticTransfer
    include Billing
    include Cancel
    include CashReceipt
    include Easy
    include Escrow
    include Link
    include Naverpay
    include PaymentResource
    include Reseller
    include Rest
    include Submit
    include Token
    include Verification
    include Wallet

    API =
      {
        development: 'https://dev-api.bootpay.co.kr/v2',
        stage:       'https://stage-api.bootpay.co.kr/v2',
        production:  'https://api.bootpay.co.kr/v2',
        ehowlsla:    'https://ehowlsla.bootpay.co.kr/api/v2'
      }.freeze

    def initialize(application_id: nil, private_key: nil, client_key: nil, secret_key: nil, mode: 'production')
      @application_id = application_id
      @private_key    = private_key
      @client_key     = client_key
      @secret_key     = secret_key
      @mode           = mode.presence || 'production'
      @token          = nil

      raise ArgumentError, "개발환경 mode는 development, stage, production 중에서 선택이 가능합니다." if API[@mode.to_sym].blank?
      if @client_key.present?
        raise ArgumentError, 'secret_key 값이 비어있습니다.' if @secret_key.blank?
      elsif @application_id.blank? || @private_key.blank?
        raise ArgumentError, 'application_id/private_key 또는 client_key/secret_key를 입력해주세요.'
      end
    end 
  end
end
