# encoding: UTF-8
$KCODE = 'UTF8' unless RUBY_VERSION >= '1.9'

require 'rest_client'
require 'ya2yaml'
require 'nokogiri'
require 'json'
require 'yaml'

require_relative 'yaml_translator/version'
require_relative 'yaml_translator/hash'

module YAMLTranslator
  autoload :ErrorMessage, 'yaml_translator/error'
  autoload :APIAuthentication, 'yaml_translator/api_authentication'
  autoload :Translation, 'yaml_translator/translation'
end 
