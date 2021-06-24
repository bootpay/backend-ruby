# frozen_string_literal: true

require_relative "lib/bootpay/version"

Gem::Specification.new do |spec|
  spec.name    = "bootpay-rest-client"
  spec.version = Bootpay::VERSION
  spec.authors = ["gosomi"]
  spec.email   = ["gosomi@bootpay.co.kr"]

  spec.summary     = "Bootpay Rest Client Version 2.0"
  spec.description = "Bootpay Rest Client Version 2.0용입니다."
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
  spec.add_dependency "activesupport", "~> 6.0"
  spec.add_dependency "http"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
