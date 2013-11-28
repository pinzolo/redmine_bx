# coding: utf-8
require "coveralls"
require "simplecov"
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter do |source_file|
    plugin_file = source_file.filename.include?("redmine_bx/app")
    ruby_file = source_file.filename.end_with?(".rb")
    if plugin_file && ruby_file
      puts source_file.filename
      false
    else
      true
    end
  end
end

require File.expand_path(File.dirname(__FILE__) + '/../../../spec/spec_helper')

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/test/fixtures"
end
