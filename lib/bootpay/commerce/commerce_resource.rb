# frozen_string_literal: true

require 'http'
require 'base64'
require 'json'

module Bootpay
  module Commerce
    class CommerceResource
      API_ENTRYPOINTS = {
        'development' => 'https://dev-api.bootapi.com/v1',
        'stage'       => 'https://stage-api.bootapi.com/v1',
        'production'  => 'https://api.bootapi.com/v1'
      }.freeze

      API_VERSION = '1.0.0'
      SDK_VERSION = '1.0.0'
      SDK_TYPE    = '305' # Ruby

      attr_reader :client_key, :secret_key, :mode

      def initialize
        @mode       = 'production'
        @token      = nil
        @role       = 'user'
        @client_key = nil
        @secret_key = nil
        @timeout    = 60
      end

      def set_configuration(client_key:, secret_key:, mode: 'production')
        @client_key = client_key
        @secret_key = secret_key
        @mode       = mode || 'production'
        raise ArgumentError, "mode는 development, stage, production 중에서 선택이 가능합니다." unless API_ENTRYPOINTS.key?(@mode)
      end

      def set_token(token)
        @token = token
      end

      def get_token
        @token
      end

      def set_role(role)
        @role = role
      end

      def get_role
        @role || 'user'
      end

      # GET request
      def get(url, params = nil)
        full_url = entrypoint(url)
        response = HTTP.headers(default_headers)
                       .timeout(@timeout)
                       .get(full_url, params: params)
        parse_response(response)
      rescue StandardError => e
        error_response(e)
      end

      # POST request with JSON body
      def post(url, data = nil)
        full_url = entrypoint(url)
        response = HTTP.headers(default_headers)
                       .timeout(@timeout)
                       .post(full_url, json: data || {})
        parse_response(response)
      rescue StandardError => e
        error_response(e)
      end

      # POST with Basic Auth (for token endpoint)
      def post_with_basic_auth(url, data = nil)
        headers = default_headers(include_auth: false)
        headers['Authorization'] = basic_auth_header
        full_url = entrypoint(url)
        response = HTTP.headers(headers)
                       .timeout(@timeout)
                       .post(full_url, json: data || {})
        parse_response(response)
      rescue StandardError => e
        error_response(e)
      end

      # POST multipart/form-data (for product images)
      def post_multipart(url, data = {}, image_paths = nil)
        headers = multipart_headers
        full_url = entrypoint(url)

        form_data = {}
        data.each do |key, value|
          next if value.nil?
          if value.is_a?(Hash) || value.is_a?(Array)
            form_data[key.to_s] = JSON.generate(value)
          else
            form_data[key.to_s] = value.to_s
          end
        end

        if image_paths && !image_paths.empty?
          files = image_paths.map do |path|
            HTTP::FormData::File.new(path)
          end
          form_data['images'] = files.length == 1 ? files.first : files
        end

        form = HTTP::FormData::Multipart.new(form_data)
        response = HTTP.headers(headers)
                       .timeout(@timeout)
                       .post(full_url, form: form)
        parse_response(response)
      rescue StandardError => e
        error_response(e)
      end

      # PUT request
      def put(url, data = nil)
        full_url = entrypoint(url)
        response = HTTP.headers(default_headers)
                       .timeout(@timeout)
                       .put(full_url, json: data || {})
        parse_response(response)
      rescue StandardError => e
        error_response(e)
      end

      # DELETE request
      def delete(url, params = nil)
        full_url = entrypoint(url)
        response = HTTP.headers(default_headers)
                       .timeout(@timeout)
                       .delete(full_url, params: params)
        parse_response(response)
      rescue StandardError => e
        error_response(e)
      end

      private

      def entrypoint(url)
        "#{API_ENTRYPOINTS[@mode]}/#{url}"
      end

      def basic_auth_header
        return '' unless @client_key && @secret_key
        credentials = Base64.strict_encode64("#{@client_key}:#{@secret_key}")
        "Basic #{credentials}"
      end

      def default_headers(include_auth: true)
        headers = {
          'Content-Type'         => 'application/json',
          'Accept'               => 'application/json',
          'Accept-Charset'       => 'utf-8',
          'BOOTPAY-SDK-VERSION'  => SDK_VERSION,
          'BOOTPAY-API-VERSION'  => API_VERSION,
          'BOOTPAY-SDK-TYPE'     => SDK_TYPE,
          'BOOTPAY-ROLE'         => @role || 'user'
        }
        headers['Authorization'] = "Bearer #{@token}" if include_auth && @token
        headers
      end

      def multipart_headers
        headers = {
          'Accept'               => 'application/json',
          'Accept-Charset'       => 'utf-8',
          'BOOTPAY-SDK-VERSION'  => SDK_VERSION,
          'BOOTPAY-API-VERSION'  => API_VERSION,
          'BOOTPAY-SDK-TYPE'     => SDK_TYPE,
          'BOOTPAY-ROLE'         => @role || 'user'
        }
        headers['Authorization'] = "Bearer #{@token}" if @token
        headers
      end

      def parse_response(response)
        JSON.parse(response.body.to_s, symbolize_names: true)
      rescue JSON::ParserError
        { success: false, message: 'Invalid JSON response' }
      end

      def error_response(error)
        { success: false, message: "Commerce API 서버와의 통신이 실패하였습니다. 오류: #{error.message}" }
      end
    end
  end
end
