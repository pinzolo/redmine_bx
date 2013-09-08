# coding: utf-8

# change fixture_path in base spec_helper.rb
#   from: config.fixture_path = "#{::Rails.root}/spec/fixtures"
#   to  : config.fixture_path = "#{::Rails.root}/test/fixtures"
require File.expand_path(File.dirname(__FILE__) + '/../../../spec/spec_helper')

RSpec.configure do |config|
  config.mock_with :mocha
  config.fixture_path = "#{::Rails.root}/test/fixtures"
end
