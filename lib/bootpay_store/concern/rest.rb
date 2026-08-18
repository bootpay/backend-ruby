module BootpayStore::Concern::Rest
  extend ActiveSupport::Concern

  included do
    private

    # HTTP Request 기본 Method
    # Comment by Gosomi
    # Date: 2021-05-21
    def request(method: :post, uri:, payload: {}, headers: {}, params: nil)
      response = HTTP.headers(
        {
          Authorization:       @token.present? ? "Bearer #{@token}" : "Basic #{basic_authentification}",
          content_type:        'application/json',
          accept:              'application/json',
          bootpay_api_version: @api_version,
          bootpay_sdk_version: Bootpay::V2_VERSION,
          bootpay_sdk_type:    '300'
        }.merge!(headers).compact
      ).send(
        method.to_sym,
        [BootpayStore::RestClient::API[@mode.to_sym], uri].join('/'),
        json:   payload,
        params: params
      )
      BootpayStore::Response.new(
        response.status.to_i == 200,
        JSON.parse(response.body.to_s, symbolize_names: true)
      )
    rescue Exception => e
      BootpayStore::Response.new(
        false,
        message:   "부트페이 API 서버와의 통신이 실패하였습니다. 오류 메세지: #{e.message}",
        backtrace: e.backtrace.join("\n")
      )
    end

    # multipart/form-data 전송 (파일 업로드용)
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    # ⚠️ content_type 을 명시하지 않는다. 명시하면 HTTP.rb 가 붙이는 boundary 가 사라져 본문이 깨진다.
    #    (Node SDK 는 인터셉터가 Content-Type 을 덮어써 본문이 null 로 전송되는 버그가 있다 — 같은 함정)
    # 기존 request 는 json: 고정이라 손대지 않고 별도 메서드로 둔다.
    def post_multipart(uri:, form: {}, headers: {})
      response = HTTP.headers(
        {
          Authorization:       @token.present? ? "Bearer #{@token}" : "Basic #{basic_authentification}",
          accept:              'application/json',
          bootpay_api_version: @api_version,
          bootpay_sdk_version: Bootpay::V2_VERSION,
          bootpay_sdk_type:    '300'
        }.merge!(headers).compact
      ).post(
        [BootpayStore::RestClient::API[@mode.to_sym], uri].join('/'),
        form: form
      )
      BootpayStore::Response.new(
        response.status.to_i == 200,
        JSON.parse(response.body.to_s, symbolize_names: true)
      )
    rescue Exception => e
      BootpayStore::Response.new(
        false,
        message:   "부트페이 API 서버와의 통신이 실패하였습니다. 오류 메세지: #{e.message}",
        backtrace: e.backtrace.join("\n")
      )
    end

    # multipart form 값 정규화 — 파일은 FormData::File 로, 나머지는 문자열로.
    # 파일은 경로(String)·IO·HTTP::FormData::File 셋 다 받는다.
    # @comment_by Claude (alfred)
    # @date: 26-08-14
    def multipart_file(value)
      return value if value.is_a?(HTTP::FormData::File)
      HTTP::FormData::File.new(value)
    end

    def multipart_value(value)
      case value
      when Array, Hash then value.to_json
      when TrueClass, FalseClass then value.to_s
      else value.to_s
      end
    end

    # basic authenticate 추가
    # Comment by GOSOMI
    # @date: 2026-02-20
    def basic_authentification
      Base64.strict_encode64("#{@client_key}:#{@secret_key}")
    end
  end
end