# frozen_string_literal: true

require_relative "lib/dependabot/gitlab/version"

Gem::Specification.new do |spec|
  spec.name          = "dependabot-gitlab"
  spec.version       = Dependabot::Gitlab::VERSION
  spec.authors       = ["storozhenkoalex"]
  spec.email         = ["storozhenkoalex@yandex.ru"]

  spec.summary       = "gem for Gitlab dependabot's updates"
  spec.description   = "gem for Gitlab dependabot's updates"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.4.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.files = %w(lib/dependabot/gitlab/updater.rb)

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
