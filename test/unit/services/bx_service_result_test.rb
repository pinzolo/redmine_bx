# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxServiceResultTest < ActiveSupport::TestCase
  def test_success
    r = BxServiceResult.new(nil, "test")
    assert r.success?
    assert_equal false, r.failure?
    assert_equal false, r.conflict?
    assert_equal false, r.error?
    assert_equal false, r.invalid_input?
  end

  def test_failure
    r = BxServiceResult.new(:test, "test")
    assert_equal false, r.success?
    assert r.failure?
    assert_equal false, r.conflict?
    assert_equal false, r.error?
    assert_equal false, r.invalid_input?
  end

  def test_data
    r = BxServiceResult.new(nil, "test")
    assert_equal "test", r.data
  end

  def test_conflict
    r = BxServiceResult.new(:conflict, "test")
    assert_equal false, r.success?
    assert r.failure?
    assert r.conflict?
    assert_equal false, r.error?
    assert_equal false, r.invalid_input?
  end

  def test_error
    r = BxServiceResult.new(:error, "test")
    assert_equal false, r.success?
    assert r.failure?
    assert_equal false, r.conflict?
    assert r.error?
    assert_equal false, r.invalid_input?
  end

  def test_invalid_input
    r = BxServiceResult.new(:invalid_input, "test")
    assert_equal false, r.success?
    assert r.failure?
    assert_equal false, r.conflict?
    assert_equal false, r.error?
    assert r.invalid_input?
  end
end

