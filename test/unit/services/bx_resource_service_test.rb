# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxResourceServiceTest < ActiveSupport::TestCase
  fixtures :projects, :issues, :users, :bx_resource_nodes, :bx_resource_branches, :bx_resource_values, :bx_resource_categories

  def setup
    User.current = User.find(1)
    @project = Project.all.first
  end

  def test_create_category_success
    assert_difference("BxResourceCategory.count") do
      form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id)
      result = BxResourceService.new(form).create_category!
      assert result.success?
    end
  end

  def test_create_category_returns_created_category
    form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id)
    result = BxResourceService.new(form).create_category!
    assert result.data.is_a?(BxResourceCategory)
  end

  def test_history_registration_on_create_category
    assert_difference("BxHistory.count") do
      form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id)
      BxResourceService.new(form).create_category!
    end
  end

  def test_history_detail_registration_on_create_category
    assert_difference("BxHistoryDetail.count", 2) do
      form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id)
      BxResourceService.new(form).create_category!
    end
  end

  def test_history_values_on_create_category
    now = Time.now
    Time.stubs(:now).returns(now)
    form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id)
    result = BxResourceService.new(form).create_category!
    history = BxHistory.where(:target => "resource_category", :source_id => result.data.id).first
    assert_equal "create", history.operation_type
    assert_equal "create_category", history.operation
    assert_equal "test", history.key
    assert_equal 1, history.changed_by
    assert_equal now, history.changed_at
  end

  def test_history_detail_values_on_create_category
    form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id)
    result = BxResourceService.new(form).create_category!
    history = BxHistory.where(:target => "resource_category", :source_id => result.data.id).first
    code_detail = history.details.detect { |detail| detail.property == "name" }
    assert_not_nil code_detail
    assert_equal "", code_detail.old_value
    assert_equal "test", code_detail.new_value
    summary_detail = history.details.detect { |detail| detail.property == "description" }
    assert_not_nil summary_detail
    assert_equal "", summary_detail.old_value
    assert_equal "description", summary_detail.new_value
  end

  def test_relational_issue_registration_on_create_category
    assert_difference("BxHistoryIssue.count", 2) do
      form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id, :relational_issues => "1,3")
      BxResourceService.new(form).create_category!
    end
  end

  def test_relational_issue_id_on_create_category
    form = BxResourceCategoryForm.new(:name => "test", :description => "description", :project_id => @project.id, :relational_issues => "1,3")
    result = BxResourceService.new(form).create_category!
    history = BxHistory.where(:target => "resource_category", :source_id => result.data.id).first
    assert history.issues.any? { |issue| issue.id == 1 }
    assert history.issues.any? { |issue| issue.id == 3 }
  end

  def test_branch_registration_on_add_branch
    assert_difference("BxResourceBranch.count") do
      category = BxResourceCategory.find(1)
      form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id)
      result = BxResourceService.new(form).add_branch!
      assert result.success?
    end
  end

  def test_branch_not_registration_on_add_branch_by_invalid_form
    assert_no_difference("BxResourceBranch.count") do
      category = BxResourceCategory.find(1)
      form = BxResourceBranchForm.new(:code => "", :name => "branch_name", :category_id => category.id)
      result = BxResourceService.new(form).add_branch!
      assert result.invalid_input?
    end
  end

  def test_registered_branch_values_on_add_branch
    category = BxResourceCategory.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id)
    result = BxResourceService.new(form).add_branch!
    branch = BxResourceBranch.where(:code => "branch_test", :category_id => category.id).first
    assert_not_nil branch
    assert_equal "branch_name", branch.name
  end

  def test_history_registration_on_add_branch
    assert_difference("BxHistory.count") do
      category = BxResourceCategory.find(1)
      form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id)
      BxResourceService.new(form).add_branch!
    end
  end

  def test_history_detail_registration_on_add_branch
    assert_difference("BxHistoryDetail.count", 2) do
      category = BxResourceCategory.find(1)
      form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id)
      BxResourceService.new(form).add_branch!
    end
  end

  def test_history_values_on_add_branch
    now = Time.now
    Time.stubs(:now).returns(now)
    category = BxResourceCategory.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id)
    result = BxResourceService.new(form).add_branch!
    history = BxHistory.where(:target => "resource_category", :source_id => category.id).last
    assert_equal "create", history.operation_type
    assert_equal "create_branch", history.operation
    assert_equal "branch_test", history.key
    assert_equal 1, history.changed_by
    assert_equal now, history.changed_at
  end

  def test_history_detail_values_on_add_branch
    category = BxResourceCategory.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id)
    result = BxResourceService.new(form).add_branch!
    history = BxHistory.where(:target => "resource_category", :source_id => category.id).last
    code_detail = history.details.detect { |detail| detail.property == "code" }
    assert_not_nil code_detail
    assert_equal "", code_detail.old_value
    assert_equal "branch_test", code_detail.new_value
    name_detail = history.details.detect { |detail| detail.property == "name" }
    assert_not_nil name_detail
    assert_equal "", name_detail.old_value
    assert_equal "branch_name", name_detail.new_value
  end

  def test_relational_issue_registration_on_add_branch
    assert_difference("BxHistoryIssue.count", 2) do
      category = BxResourceCategory.find(1)
      form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id, :relational_issues => "1,3")
      BxResourceService.new(form).add_branch!
    end
  end

  def test_relational_issue_id_on_add_branch
    category = BxResourceCategory.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :category_id => category.id, :relational_issues => "1,3")
    result = BxResourceService.new(form).add_branch!
    history = BxHistory.where(:target => "resource_category", :source_id => category.id).first
    assert history.issues.any? { |issue| issue.id == 1 }
    assert history.issues.any? { |issue| issue.id == 3 }
  end

  def test_update_branch
    branch = BxResourceBranch.find(1)
    form = self.form_for_update(branch)
    result = BxResourceService.new(form).update_branch!(branch)
    assert result.success?
    target_branch = BxResourceBranch.find(1)
    assert_equal "de", target_branch.code
    assert_equal "German", target_branch.name
  end

  def test_not_update_on_update_branch_by_invalid_form
    branch = BxResourceBranch.find(1)
    form = self.form_for_update(branch)
    form.code = ""
    result = BxResourceService.new(form).update_branch!(branch)
    assert result.failure?
    assert result.invalid_input?
    target_branch = BxResourceBranch.find(1)
    assert_equal "ja", target_branch.code
    assert_equal "Japanese", target_branch.name
  end

  def test_not_update_on_update_branch_by_conflict
    branch = BxResourceBranch.find(1)
    form = self.form_for_update(branch)
    branch.update_attributes!(:code => "fr", :name => "French")
    result = BxResourceService.new(form).update_branch!(branch)
    assert result.failure?
    assert result.conflict?
    target_branch = BxResourceBranch.find(1)
    assert_equal "fr", target_branch.code
    assert_equal "French", target_branch.name
  end

  def test_history_registration_on_update_branch
    assert_difference("BxHistory.count") do
      branch = BxResourceBranch.find(1)
      form = self.form_for_update(branch)
      BxResourceService.new(form).update_branch!(branch)
    end
  end

  def test_history_detail_registration_on_update_branch
    assert_difference("BxHistoryDetail.count", 2) do
      branch = BxResourceBranch.find(1)
      form = self.form_for_update(branch)
      BxResourceService.new(form).update_branch!(branch)
    end
  end

  def test_history_values_on_update_branch
    now = Time.now
    Time.stubs(:now).returns(now)
    branch = BxResourceBranch.find(1)
    form = self.form_for_update(branch)
    BxResourceService.new(form).update_branch!(branch)
    history = BxHistory.where(:target => "resource_category", :source_id => branch.category_id).last
    assert_equal "update", history.operation_type
    assert_equal "update_branch", history.operation
    assert_equal "de", history.key
    assert_equal 1, history.changed_by
    assert_equal now, history.changed_at
  end

  def test_history_detail_values_on_update_branch
    branch = BxResourceBranch.find(1)
    form = self.form_for_update(branch)
    BxResourceService.new(form).update_branch!(branch)
    history = BxHistory.where(:target => "resource_category", :source_id => branch.category_id).last
    code_detail = history.details.detect { |detail| detail.property == "code" }
    assert_not_nil code_detail
    assert_equal "ja", code_detail.old_value
    assert_equal "de", code_detail.new_value
    name_detail = history.details.detect { |detail| detail.property == "name" }
    assert_not_nil name_detail
    assert_equal "Japanese", name_detail.old_value
    assert_equal "German", name_detail.new_value
  end

  def test_relational_issue_registration_on_update_branch
    assert_difference("BxHistoryIssue.count", 2) do
      branch = BxResourceBranch.find(1)
      form = self.form_for_update(branch)
      form.relational_issues = "1,3"
      BxResourceService.new(form).update_branch!(branch)
    end
  end

  def test_relational_issue_id_on_update_branch
    branch = BxResourceBranch.find(1)
    form = self.form_for_update(branch)
    form.relational_issues = "1,3"
    BxResourceService.new(form).update_branch!(branch)
    history = BxHistory.where(:target => "resource_category", :source_id => branch.category_id).first
    assert history.issues.any? { |issue| issue.id == 1 }
    assert history.issues.any? { |issue| issue.id == 3 }
  end

  def form_for_update(branch)
    form = BxResourceBranchForm.new
    form.load(:branch => branch)
    form.code = "de"
    form.name = "German"
    form
  end

  def test_delete_branch
    assert_difference("BxResourceBranch.count", -1) do
      branch = BxResourceBranch.find(1)
      BxResourceService.new.delete_branch!(branch)
    end
  end

  def test_value_deletion_on_delete_branch
    assert_difference("BxResourceValue.where(:branch_id => 1).count", -5) do
      branch = BxResourceBranch.find(1)
      BxResourceService.new.delete_branch!(branch)
    end
  end

  def test_history_registration_on_delete_branch
    assert_difference("BxHistory.count") do
      branch = BxResourceBranch.find(1)
      BxResourceService.new.delete_branch!(branch)
    end
  end

  def test_history_detail_registration_on_update_branch
    assert_no_difference("BxHistoryDetail.count") do
      branch = BxResourceBranch.find(1)
      BxResourceService.new.delete_branch!(branch)
    end
  end

  def test_history_values_on_delete_branch
    now = Time.now
    Time.stubs(:now).returns(now)
    branch = BxResourceBranch.find(1)
    BxResourceService.new.delete_branch!(branch)
    history = BxHistory.where(:target => "resource_category", :source_id => branch.category_id).last
    assert_equal "delete", history.operation_type
    assert_equal "delete_branch", history.operation
    assert_equal "ja", history.key
    assert_equal 1, history.changed_by
    assert_equal now, history.changed_at
  end
end

