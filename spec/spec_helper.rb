# coding: utf-8
require "coveralls"
require "simplecov"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter do |source_file|
    !source_file.filename.include?("plugins/redmine_bx") || !source_file.filename.end_with?(".rb")
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../../../spec/spec_helper')

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/test/fixtures"
end
