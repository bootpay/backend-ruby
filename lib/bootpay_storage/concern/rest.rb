module BootpayStorage::Concern::Rest
  extend ActiveSupport::Concern

  included do
    private

    # HTTP Request 기본 Method
    # Comment by Gosomi
    # Date: 2021-05-21
    def request(method: :post, uri:, payload: {}, headers: {}, params: nil)
      response = HTTP.headers(
        {
          Authorization:       "Bearer #{@token}",
          content_type:        'application/json',
          accept:              'application/json',
          bootpay_api_version: @api_version,
          bootpay_sdk_version: Bootpay::V2_VERSION,
          bootpay_sdk_type:    '300'
        }.merge!(headers).compact
      ).send(
        method.to_sym,
        [BootpayStorage::RestClient::API[@mode.to_sym], uri].join('/'),
        json:   payload,
        params: params
      )
      BootpayStorage::Response.new(
        response.status.to_i == 200,
        JSON.parse(response.body.to_s, symbolize_names: true)
      )
    rescue Exception => e
      BootpayStorage::Response.new(
        false,
        message:   "부트페이 API 서버와의 통신이 실패하였습니다. 오류 메세지: #{e.message}",
        backtrace: e.backtrace.join("\n")
      )
    end

    # Multipart 파일 전송 Method
    # Comment by Gosomi
    # Date: 2025-03-25
    def upload(uri:, images:, headers: {}, params: nil)
      # 이미지 데이터를 배열로 받음
      files = images.each_with_index.map do |data, index|
        filename = "image_#{Time.now.to_i}_#{index}.jpg"
        HTTP::FormData::File.new(data, filename: filename)
      end

      # HTTP 요청
      response = HTTP.headers(
        {
          Authorization:       "Bearer #{@token}",
          accept:              'application/json',
          bootpay_api_version: @api_version,
          bootpay_sdk_version: Bootpay::V2_VERSION,
          bootpay_sdk_type:    '300'
        }.merge!(headers).compact
      ).post(
        [BootpayStorage::RestClient::API[@mode.to_sym], uri].join('/'),
        form: { images: files },
        params: params
      )

      # JSON 파싱 시도
      parsed_response = begin
                          JSON.parse(response.body.to_s, symbolize_names: true)
                        rescue JSON::ParserError => e
                          { error: "응답 파싱 실패: #{e.message}", body: response.body.to_s }
                        end

      # 응답 처리
      BootpayStorage::Response.new(
        response.status.to_i == 200,
        parsed_response
      )
    rescue Exception => e
      BootpayStorage::Response.new(
        false,
        message:   "파일 업로드 실패: #{e.message}",
        backtrace: e.backtrace.join("\n")
      )
    end


    # def upload(uri:, image_data:, image_name:, headers: {}, params: nil)
    #
    #   # puts [BootpayStorage::RestClient::API[@mode.to_sym], uri].join('/')
    #
    #   # 파일 객체 생성
    #   file = HTTP::FormData::File.new(image_data, filename: image_name)
    #
    #   # HTTP 요청
    #   response = HTTP.headers(
    #     {
    #       Authorization:       "Bearer #{@token}",
    #       accept:              'application/json',
    #       bootpay_api_version: @api_version,
    #       bootpay_sdk_version: Bootpay::V2_VERSION,
    #       bootpay_sdk_type:    '300'
    #     }.merge!(headers).compact
    #   ).post(
    #     [BootpayStorage::RestClient::API[@mode.to_sym], uri].join('/'),
    #     form: { images: [file] },
    #     params: params
    #   )
    #
    #   # 응답 상태와 바디 출력
    #   puts "Response Status: #{response.status}"
    #   puts "Response Body: #{response.body.to_s}"
    #
    #   # JSON 파싱 시도
    #   parsed_response = begin
    #                       JSON.parse(response.body.to_s, symbolize_names: true)
    #                     rescue JSON::ParserError => e
    #                       { error: "응답 파싱 실패: #{e.message}", body: response.body.to_s }
    #                     end
    #
    #   # 응답 처리
    #   BootpayStorage::Response.new(
    #     response.status.to_i == 200,
    #     parsed_response
    #   )
    # rescue Exception => e
    #   BootpayStorage::Response.new(
    #     false,
    #     message:   "파일 업로드 실패: #{e.message}",
    #     backtrace: e.backtrace.join("\n")
    #   )
    # end

  end
end