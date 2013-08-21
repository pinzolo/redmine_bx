# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class TestForm
  def initialize(flag)
    @flag = flag
  end

  def valid?
    @flag
  end
end
class TestService
  include BxService

  def do_something
    "something"
  end

  def raise_error
    raise "error"
  end

  def raise_conflict
    raise ActiveRecord::StaleObjectError.new("action", "record")
  end
end

class BxServiceResultTest < ActiveSupport::TestCase

  def test_can_call_original_method
    assert_equal "something", TestService.new.do_something
  end

  def test_respond_to
    service = TestService.new
    assert service.respond_to?(:do_something!)
    assert service.respond_to?(:raise_error!)
    assert service.respond_to?(:raise_conflict!)
  end

  def test_call_auto_defined_method
    result = TestService.new.do_something!
    assert result.success?
    assert_equal "something", result.data
  end

  def test_by_valid_input
    form = TestForm.new(true)
    result = TestService.new(form).do_something!
    assert result.success?
    assert_equal "something", result.data
  end

  def test_by_invalid_form
    form = TestForm.new(false)
    result = TestService.new(form).do_something!
    assert result.failure?
    assert result.invalid_input?
    assert_nil result.data
  end

  def test_on_conflict_raised
    result = TestService.new.raise_conflict!
    assert result.failure?
    assert result.conflict?
    assert result.data.is_a?(ActiveRecord::StaleObjectError)
  end

  def test_on_error_raised
    result = TestService.new.raise_error!
    assert result.failure?
    assert result.error?
    assert result.data.is_a?(StandardError)
  end
end
