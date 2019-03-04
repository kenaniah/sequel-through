lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sequel/through/version"

Gem::Specification.new do |spec|
  spec.name          = "sequel-through"
  spec.version       = Sequel::Through::VERSION
  spec.authors       = ["Kenaniah Cerny"]
  spec.email         = ["kenaniah@gmail.com"]

  spec.summary       = "Adds support for :through associations to sequel"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/kenaniah/sequel-through"
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/kenaniah/sequel-through"
    spec.metadata["changelog_uri"] = "https://github.com/kenaniah/sequel-through/blob/master/CHANGELOG.md"
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
