# frozen_string_literal: true

# 리포 루트의 .env(gitignore, 로컬 전용)를 ENV 로 읽는다. 이미 설정된 환경변수가 우선한다.
# spec 의 키는 ENV['BP_CLIENT_KEY'] · ENV['BP_SECRET_KEY'] · ENV['BOOTPAY_APPLICATION_ID'] · ENV['BOOTPAY_PRIVATE_KEY'] 로만 받는다.
env_file = File.expand_path('../.env', __dir__)
if File.exist?(env_file)
  File.foreach(env_file) do |line|
    next if line.strip.empty? || line.lstrip.start_with?('#')
    key, value = line.strip.split('=', 2)
    ENV[key] ||= value.to_s.delete_prefix('"').delete_suffix('"') if key && value
  end
end

require "bootpay/bootpay-rest-client"
require "bootpay_store/bootpay-store-rest-client"
require "bootpay_storage/bootpay-storage-rest-client"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
