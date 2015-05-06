require 'rails_helper'
require 'rspec_api_documentation/dsl'
require 'support/factory_girl'

RspecApiDocumentation.configure do |config|
  config.format    = [:json, :combined_text, :html]
  config.curl_host = 'http://api.ngoaidmap.org'
  config.api_name  = "API NGO Aid Map"
end
