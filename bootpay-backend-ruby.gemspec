# frozen_string_literal: true

require_relative "lib/bootpay/version"

Gem::Specification.new do |spec|
  spec.name    = "bootpay-backend-ruby"
  spec.version = Bootpay::V2_VERSION
  spec.authors = ["gosomi"]
  spec.email   = ["gosomi@bootpay.co.kr"]

  spec.summary     = "Bootpay Ruby REST Client"
  spec.description = "부트페이 공식 Ruby 서버사이드 모듈입니다. 결제조회, 취소, 빌링키 결제시 사용됩니다."
  spec.license     = "MIT"
  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport"
  spec.add_dependency "http"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
