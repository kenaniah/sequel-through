lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "sequel-through"
  spec.version       = "0.1.0"
  spec.authors       = ["Kenaniah Cerny"]
  spec.email         = ["kenaniah@gmail.com"]

  spec.summary       = "Adds support for :through associations to sequel"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/kenaniah/sequel-through"
  spec.license       = "MIT"

  s.required_ruby_version = ">= 2.4"

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

  spec.add_dependency  "sequel", "~> 5"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
end
