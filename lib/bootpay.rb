require 'active_support/all'
require 'http'
require_relative 'response'
require_relative 'bootpay/billing'
require_relative 'bootpay/cancel'
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

module Bootpay
  class Api
    include Billing
    include Cancel
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

    API =
      {
        development: 'https://dev-api.bootpay.co.kr/',
        stage:       'https://stage-api.bootpay.co.kr/',
        production:  'https://api.bootpay.co.kr/'
      }.freeze

    def initialize(application_id:, private_key:, mode: 'production')
    
      @application_id = application_id
      @private_key    = private_key
      @mode           = mode.presence || 'production'
      @token          = nil
      raise ArgumentError, "개발환경 mode는 development, stage, production 중에서 선택이 가능합니다." if API[@mode.to_sym].blank?
    end 
  end
end
