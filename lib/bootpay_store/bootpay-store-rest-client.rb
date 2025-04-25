# frozen_string_literal: true

require 'active_support/all'
require 'http'
require_relative 'response'
require_relative '../version'
require_relative 'concern'

module BootpayStore
  class RestClient
    include Concern

    API =
      {
        development: 'https://dev-api.bootapi.com/v1',
        stage:       'https://stage-api.bootapi.com/v1',
        production:  'https://api.bootapi.com/v1'
      }

    SDK_VERSION = '5.0.0'

    def initialize(server_key:, private_key:, mode: 'production')
      @server_key  = server_key
      @private_key = private_key
      @mode        = mode.presence || 'production'
      @token       = nil
      @api_version = SDK_VERSION
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
