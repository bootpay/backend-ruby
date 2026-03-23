# frozen_string_literal: true

require "bootpay"
require "bootpay_commerce"

# 환경 설정: BOOTPAY_ENV 환경변수로 development/production 전환 (기본: development)
BOOTPAY_ENV = ENV.fetch('BOOTPAY_ENV', 'development')

# PG API 키
PG_KEYS = {
  'development' => {
    application_id: '59bfc738e13f337dbd6ca48a',
    private_key:    'pDc0NwlkEX3aSaHTp/PPL/i8vn5E/CqRChgyEp/gHD0='
  },
  'production' => {
    application_id: '5b8f6a4d396fa665fdc2b5ea',
    private_key:    'rm6EYECr6aroQVG2ntW0A6LpWnkTgP4uQ3H18sDDUYw='
  }
}.freeze

# Commerce API 키
COMMERCE_KEYS = {
  'development' => {
    client_key: 'hxS-Up--5RvT6oU6QJE0JA',
    secret_key: 'r5zxvDcQJiAP2PBQ0aJjSHQtblNmYFt6uFoEMhti_mg='
  },
  'production' => {
    client_key: 'sEN72kYZBiyMNytA8nUGxQ',
    secret_key: 'rnZLJamENRgfwTccwmI_Uu9cxsPpAV9X2W-Htg73yfU='
  }
}.freeze

def pg_keys
  PG_KEYS[BOOTPAY_ENV]
end

def commerce_keys
  COMMERCE_KEYS[BOOTPAY_ENV]
end

# PG API 인스턴스 생성 헬퍼
def create_pg_api
  Bootpay::Api.new(
    application_id: pg_keys[:application_id],
    private_key:    pg_keys[:private_key],
    mode:           BOOTPAY_ENV
  )
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
