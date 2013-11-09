# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'yaml_translator/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Arif Qodari"]
  gem.email         = ["arif.qodari@gmail.com"]
  gem.description   = %q{Ruby library to translate YAML file using Microsoft Translate HTTP API}
  gem.summary       = %q{Translate a YAML file}
  gem.homepage      = "https://github.com/arifqodari/yaml_translator"

  gem.files         = `git ls-files`.split("\n")
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.name          = "yaml_translator"
  gem.require_paths = ["lib"]
  gem.version       = YAMLTranslator::VERSION
  gem.license       = 'MIT'

  gem.add_development_dependency 'rake'
  gem.add_runtime_dependency "rest-client", [">= 1.6.7"]
  gem.add_runtime_dependency "nokogiri", [">= 1.6.0"]
  gem.add_runtime_dependency "ya2yaml", [">= 0.31"]
end
