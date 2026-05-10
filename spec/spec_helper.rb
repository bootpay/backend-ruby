# frozen_string_literal: true

require "bootpay"
require "bootpay_commerce"

def load_bootpay_dotenv
  [File.expand_path('../.env', __dir__), File.expand_path('.env', __dir__)].each do |file|
    next unless File.exist?(file)

    File.readlines(file, chomp: true).each do |line|
      line = line.strip
      next if line.empty? || line.start_with?('#') || !line.include?('=')

      key, value = line.split('=', 2)
      ENV[key.strip] ||= value.strip.gsub(/\A["']|["']\z/, '')
    end
  end
end

def bootpay_env(key, fallback)
  value = ENV[key]
  value.nil? || value.empty? ? fallback : value
end

load_bootpay_dotenv

# 환경 설정: BOOTPAY_ENV 환경변수로 development/production 전환 (기본: production)
BOOTPAY_ENV = bootpay_env('BOOTPAY_ENV', 'production')

# PG 인증 방식: 'new' (client_key/secret_key) 또는 'legacy' (application_id/private_key)
# 매 실행 시 BOOTPAY_AUTH_MODE 환경변수로 토글한다.
BOOTPAY_AUTH_MODE = bootpay_env('BOOTPAY_AUTH_MODE', 'new').downcase

# PG/Commerce API 키 - .env / 환경변수 로 주입한다 (.env.example 참고)
PG_KEYS = {
  'development' => {
    client_key: bootpay_env('BOOTPAY_PG_CLIENT_KEY_DEV', ''),
    secret_key: bootpay_env('BOOTPAY_PG_SECRET_KEY_DEV', '')
  },
  'production' => {
    client_key: bootpay_env('BOOTPAY_PG_CLIENT_KEY_PROD', ''),
    secret_key: bootpay_env('BOOTPAY_PG_SECRET_KEY_PROD', '')
  }
}.freeze

# Legacy application_id/private_key (호환성 검증용). ck/sk 와 별개로 유지하여 두 인증 모드를 모두 테스트한다.
PG_LEGACY_KEYS = {
  'development' => {
    application_id: bootpay_env('BOOTPAY_PG_APPLICATION_ID_DEV', ''),
    private_key:    bootpay_env('BOOTPAY_PG_PRIVATE_KEY_DEV', '')
  },
  'production' => {
    application_id: bootpay_env('BOOTPAY_PG_APPLICATION_ID_PROD', ''),
    private_key:    bootpay_env('BOOTPAY_PG_PRIVATE_KEY_PROD', '')
  }
}.freeze

COMMERCE_KEYS = {
  'development' => {
    client_key: bootpay_env('BOOTPAY_COMMERCE_CLIENT_KEY_DEV', ''),
    secret_key: bootpay_env('BOOTPAY_COMMERCE_SECRET_KEY_DEV', '')
  },
  'production' => {
    client_key: bootpay_env('BOOTPAY_COMMERCE_CLIENT_KEY_PROD', ''),
    secret_key: bootpay_env('BOOTPAY_COMMERCE_SECRET_KEY_PROD', '')
  }
}.freeze

# 테스트 데이터 (nodejs/test/config.js TEST_DATA 와 1:1 mirror).
TEST_DATA = {
  receipt_id:             '628b2206d01c7e00209b6087',
  receipt_id_confirm:     '62876963d01c7e00209b6028',
  receipt_id_cash:        '62e0f11f1fc192036b1b3c92',
  receipt_id_escrow:      '628ae7ffd01c7e001e9b6066',
  receipt_id_billing:     '62c7ccebcf9f6d001b3adcd4',
  receipt_id_transfer:    '66541bc4ca4517e69343e24c',
  billing_key:            '628b2644d01c7e00209b6092',
  billing_key_2:          '66542dfb4d18d5fc7b43e1b6',
  reserve_id:             '6490149ca575b40024f0b70d',
  reserve_id_2:           '628b316cd01c7e00219b6081',
  user_id:                '1234',
  certificate_receipt_id: '69fd7187564d1f550535538c'
}.freeze

def pg_keys
  PG_KEYS[BOOTPAY_ENV]
end

def pg_legacy_keys
  PG_LEGACY_KEYS[BOOTPAY_ENV]
end

def commerce_keys
  COMMERCE_KEYS[BOOTPAY_ENV]
end

# PG API 인스턴스 생성 헬퍼 (ck/sk 명시)
def create_pg_api_ck
  Bootpay::Api.new(
    client_key: pg_keys[:client_key],
    secret_key: pg_keys[:secret_key],
    mode:       BOOTPAY_ENV
  )
end

# PG API 인스턴스 생성 헬퍼 (legacy application_id/private_key 명시 — 호환성 검증용)
def create_pg_legacy_api
  Bootpay::Api.new(
    application_id: pg_legacy_keys[:application_id],
    private_key:    pg_legacy_keys[:private_key],
    mode:           BOOTPAY_ENV
  )
end

# PG API 인스턴스 생성 헬퍼 — BOOTPAY_AUTH_MODE 에 따라 ck/sk 또는 legacy.
# 일반 spec 은 이 헬퍼를 사용하면 두 모드를 환경변수만으로 전환할 수 있다.
def create_pg_api
  if BOOTPAY_AUTH_MODE == 'legacy'
    puts "[BOOTPAY_AUTH_MODE=legacy] PG: application_id/private_key (Bearer) | env=#{BOOTPAY_ENV}"
    create_pg_legacy_api
  else
    puts "[BOOTPAY_AUTH_MODE=new] PG: client_key/secret_key (Basic Auth) | env=#{BOOTPAY_ENV}"
    create_pg_api_ck
  end
end

# Commerce API 인스턴스 생성 헬퍼
def create_commerce_api
  Bootpay::Commerce::Api.new(
    client_key: commerce_keys[:client_key],
    secret_key: commerce_keys[:secret_key],
    mode:       BOOTPAY_ENV
  )
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # integration 태그가 붙은 테스트만 실행하려면: rspec --tag integration
  config.filter_run_when_matching :focus
end
