# frozen_string_literal: true

require 'active_support/all'
require 'http'
require 'base64'
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

    # 알림톡 API 전용 — 메시지 API 가 직접 받는다(경로에 /v1 없음). concern/rest.rb#api_base_url 이 고른다.
    # @date: 26-09-18
    MESSAGE_API =
      {
        development: 'https://dev-m.bootapi.com',
        stage:       'https://stage-m.bootapi.com',
        production:  'https://message.bootapi.com'
      }

    SDK_VERSION = '5.0.0'

    def initialize(client_key: nil, private_key: nil, server_key: nil, secret_key: nil, mode: 'production')
      @client_key  = server_key.presence || client_key
      @secret_key  = private_key.presence || secret_key
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

    # 알림톡(메시지 API) URL을 변경
    # @date: 26-09-18
    def set_message_api_url(url)
      MESSAGE_API[@mode.to_sym] = url
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
