# frozen_string_literal: true

# 구 gem 이름(`bootpay-backend-ruby`) 호환 진입점.
# 정본 gem 은 `bootpay` 이고 진입점은 lib/bootpay.rb 다.
# 이미 `require 'bootpay-backend-ruby'` 로 쓰던 코드가 깨지지 않도록 남겨 둔다.
require_relative "bootpay"
