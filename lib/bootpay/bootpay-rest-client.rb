# frozen_string_literal: true

require 'active_support/all'
require 'http'
require_relative 'response'
require_relative '../version'
require_relative 'concern'

module Bootpay
  class RestClient
    include Concern

    attr_accessor :application_id, :private_key, :client_key, :secret_key, :use_client_key, :mode, :token, :api_version

    API =
      {
        development: 'https://dev-api.bootpay.co.kr/v2',
        stage:       'https://stage-api.bootpay.co.kr/v2',
        production:  'https://api.bootpay.co.kr/v2'
      }

    SDK_VERSION = '5.3.0'

    def initialize(application_id: nil, private_key: nil, client_key: nil, secret_key: nil, mode: 'production')
      @application_id = application_id
      @private_key    = private_key
      @client_key     = client_key
      @secret_key     = secret_key
      @use_client_key = client_key.present?
      @mode           = mode.presence || 'production'
      @token          = nil
      @api_version    = SDK_VERSION
      raise ArgumentError, "개발환경 mode는 development, stage, production 중에서 선택이 가능합니다." if API[@mode.to_sym].blank?
    end

    # API URL을 변경
    # Comment by GOSOMI
    # @date: 2023-05-26
    def set_api_url(url)
      API[@mode.to_sym] = url
    end

    # API 버전을 설정한다
    # Comment by Gosomi
    # Date: 2022-07-29
    def set_api_version(version)
      raise ArgumentError, 'API Version은 4.0.0 이상만 설정이 가능합니다.' if version < '4.0.0'
      @api_version = version
    end
  end
end
