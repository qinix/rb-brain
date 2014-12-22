# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "rb-brain"
  gem.version       = "0.0.1"
  gem.authors       = ["Eric Zhang"]
  gem.email         = ["i@qinix.com"]
  gem.description   = %q{rb-brain is an easy-to-use neural network written in ruby}
  gem.summary       = %q{rb-brain is an easy-to-use neural network written in ruby}
  gem.homepage      = "https://github.com/qinix/rb-brain"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

end
