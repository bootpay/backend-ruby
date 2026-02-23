require 'base64'
require 'json'
require 'http'

client_key = ENV['BP_CLIENT_KEY'] || 'QIzXk4M3EeD-6B1GTfmGHA'
secret_key = ENV['BP_SECRET_KEY'] || 'vRle44QfyBj7nzJlBbeebqkbtlJVRTS2DQa9Adpz3d8='
base_url = ENV['BP_BASE_URL'] || 'https://dev-api.bootapi.com/v1'

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
