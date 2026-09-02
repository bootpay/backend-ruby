# frozen_string_literal: true

require_relative "lib/version"

Gem::Specification.new do |spec|
  spec.name    = "bootpay"
  spec.version = Bootpay::VERSION
  spec.authors = ["gosomi"]
  spec.email   = ["gosomi@bootpay.co.kr"]

  spec.summary     = "Bootpay Ruby REST Client"
  spec.description = "부트페이 공식 Ruby 서버사이드 모듈입니다. 결제조회, 취소, 빌링키 결제시 사용됩니다."
  spec.license     = "MIT"
  spec.homepage    = "https://www.bootpay.ai"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bootpay/backend-ruby/tree/2-x-development"
  spec.metadata["changelog_uri"]   = "https://github.com/bootpay/backend-ruby/blob/2-x-development/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://developers.bootpay.ai"
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # ⚠️ 루트의 tests_*.rb / *.gem 도 제외한다 — 종전 규칙은 test/·spec/·features/ **디렉터리**만
  #    걸러서 루트에 있던 tests_basic_auth_product_info.rb 가 gem 에 실려 나갔다.
  #    그 파일에는 dev Commerce secret_key 가 하드코딩돼 있었다 (26-09-02).
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{\A(?:test|spec|features)/}) ||
        f.match(%r{\A(?:tests?_.*\.rb|.*\.gem)\z}) ||
        f.match(%r{\A\.env})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport"
  spec.add_dependency "http"
  spec.add_dependency "addressable"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
