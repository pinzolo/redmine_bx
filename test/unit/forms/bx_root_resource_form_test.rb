# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxRootResourceFormTest < ActiveSupport::TestCase
  fixtures :projects, :bx_resource_nodes

  def setup
    @form = BxRootResourceForm.new(:resource_id => 1, :resource_code => "code", :resource_summary => "summary", :project => Project.all.first, :relational_issues => "1,2,3")
  end

  def test_handle_project
    assert @form.valid?
    assert_equal Project.all.first, @form.project
  end

  def test_handle_relational_issues
    assert @form.valid?
    assert_equal [1,2,3], @form.relational_issue_ids
  end

  def test_validates_presence_of_summary
    @form.resource_summary = nil
    assert_equal false, @form.valid?
    @form.resource_summary = ""
    assert_equal false, @form.valid?
  end

  def test_validates_presence_of_code
    @form.resource_code = nil
    assert_equal false, @form.valid?
    @form.resource_code = ""
    assert_equal false, @form.valid?
  end

  def test_validates_length_of_summary
    @form.resource_summary = "a" * 255
    assert_equal true, @form.valid?
    @form.resource_summary = "a" * 256
    assert_equal false, @form.valid?
  end

  def test_validates_length_of_code
    @form.resource_code = "a" * 255
    assert_equal true, @form.valid?
    @form.resource_code = "a" * 256
    assert_equal false, @form.valid?
  end

  def test_validates_uniqueness_of_code
    @form.resource_code = "locales"
    assert_equal false, @form.valid?
  end
end
