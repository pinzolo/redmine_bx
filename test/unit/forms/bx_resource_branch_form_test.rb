# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxResourceBranchFormTest < ActiveSupport::TestCase
  fixtures :issues, :bx_resource_branches

  def setup
    @form = BxResourceBranchForm.new(:root_node_id => 1, :code => "code", :name => "name", :relational_issues => "1,2,3")
  end

  def test_handle_relational_issues
    assert @form.valid?
    assert_equal [1,2,3], @form.relational_issue_ids
  end

  def test_validates_presence_of_name
    @form.name = nil
    assert_equal false, @form.valid?
    @form.name = ""
    assert_equal false, @form.valid?
  end

  def test_validates_presence_of_code
    @form.code = nil
    assert_equal false, @form.valid?
    @form.code = ""
    assert_equal false, @form.valid?
  end

  def test_validates_length_of_name
    @form.name = "a" * 255
    assert_equal true, @form.valid?
    @form.name = "a" * 256
    assert_equal false, @form.valid?
  end

  def test_validates_length_of_code
    @form.code = "a" * 255
    assert_equal true, @form.valid?
    @form.code = "a" * 256
    assert_equal false, @form.valid?
  end

  def test_validates_uniqueness_of_code
    @form.code = "ja"
    assert_equal false, @form.valid?
  end
end

