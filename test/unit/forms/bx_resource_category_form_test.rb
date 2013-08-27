# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxResourceCategoryFormTest < ActiveSupport::TestCase
  fixtures :projects, :issues

  def setup
    @form = BxResourceCategoryForm.new(:name => "name", :description => "description", :project_id => Project.all.first.id, :relational_issues => "1,2,3")
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

  def test_validates_length_of_name
    @form.name = "a" * 255
    assert_equal true, @form.valid?
    @form.name = "a" * 256
    assert_equal false, @form.valid?
  end
end
