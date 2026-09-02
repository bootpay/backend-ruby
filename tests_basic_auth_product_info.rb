# frozen_string_literal: true

# Commerce Basic Auth smoke test — /products 를 한 번 호출하고 응답을 확인한다.
#
# ⚠️ 키는 반드시 환경변수로 주입한다. 하드코딩 금지 —
#    이 파일은 gem 에 포함되지 않지만(gemspec 이 tests_* 를 제외한다), 리포는 공개다.
#
#   BP_CLIENT_KEY  Commerce client_key
#   BP_SECRET_KEY  Commerce secret_key
#   BP_BASE_URL    기본 https://api.bootapi.com/v1 (development 는 dev-api.bootapi.com/v1)
#
# 실행: BP_CLIENT_KEY=... BP_SECRET_KEY=... ruby tests_basic_auth_product_info.rb

require 'base64'
require 'json'
require 'http'

client_key = ENV['BP_CLIENT_KEY']
secret_key = ENV['BP_SECRET_KEY']
base_url   = ENV['BP_BASE_URL'] || 'https://api.bootapi.com/v1'

if client_key.to_s.empty? || secret_key.to_s.empty?
  warn 'BP_CLIENT_KEY / BP_SECRET_KEY 환경변수가 필요합니다.'
  warn '예: BP_CLIENT_KEY=... BP_SECRET_KEY=... BP_BASE_URL=https://dev-api.bootapi.com/v1 ruby tests_basic_auth_product_info.rb'
  exit(2)
end

basic = Base64.strict_encode64("#{client_key}:#{secret_key}")
response = HTTP.headers(
  'Authorization' => "Basic #{basic}",
  'Accept' => 'application/json',
  'Content-Type' => 'application/json',
  'bootpay_api_version' => '5.0.0',
  'bootpay_sdk_version' => '5.0.0',
  'bootpay_sdk_type' => '300'
).get("#{base_url}/products?page=1&limit=1")

body = response.to_s
puts({ status: response.code.to_i, ok: response.code.to_i == 200, preview: body[0, 500] }.to_json)
exit(1) unless response.code.to_i == 200
