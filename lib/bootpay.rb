# frozen_string_literal: true

# `gem 'bootpay'` 의 기본 진입점.
# Bundler 는 gem 이름과 같은 파일을 자동으로 require 하므로 이 파일이 없으면 부팅에서 LoadError 가 난다.
#
# 구 이름 `bootpay-backend-ruby` 로 require 하던 코드도 그대로 동작한다
# (lib/bootpay-backend-ruby.rb 가 이 파일과 같은 내용을 로드한다).
require_relative "bootpay/bootpay-rest-client"
require_relative "bootpay_storage/bootpay-storage-rest-client"
require_relative "bootpay_store/bootpay-store-rest-client"
