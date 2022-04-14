# frozen_string_literal: true

require 'active_support/all'
require 'http'
require_relative 'response'
require_relative 'bootpay/version'
require_relative 'bootpay/concern'

module Bootpay
  class RestClient
    include Concern

    API =
      {
        development: 'https://dev-api.bootpay.co.kr/v2',
        stage:       'https://stage-api.bootpay.co.kr/v2',
        production:  'https://api.bootpay.co.kr/v2'
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
