# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxResourceServiceTest < ActiveSupport::TestCase
  fixtures :projects, :issues, :users, :bx_resource_nodes, :bx_resource_branches

  def setup
    User.current = User.find(1)
    @project = Project.all.first
  end

  def test_create_root_success
    assert_difference("BxResourceNode.count") do
      form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
      result = BxResourceService.new(form).create_root!
      assert result.success?
    end
  end

  def test_create_root_returns_created_root
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
    result = BxResourceService.new(form).create_root!
    assert result.data.is_a?(BxResourceNode)
  end

  def test_create_root_saving_root_node
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
    result = BxResourceService.new(form).create_root!
    assert result.success?
    node = BxResourceNode.where(:project_id => @project.id, :code => "test").first
    assert node.root?
    assert_equal node.root_node_id, node.id
  end

  def test_history_registration_on_create_root
    assert_difference("BxHistory.count") do
      form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
      BxResourceService.new(form).create_root!
    end
  end

  def test_history_detail_registration_on_create_root
    assert_difference("BxHistoryDetail.count", 2) do
      form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
      BxResourceService.new(form).create_root!
    end
  end

  def test_history_values_on_create_root
    now = Time.now
    Time.stubs(:now).returns(now)
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
    result = BxResourceService.new(form).create_root!
    history = BxHistory.where(:target => "resource", :source_id => result.data.id).first
    assert_equal "create", history.operation_type
    assert_equal "create_root", history.operation
    assert_equal 1, history.changed_by
    assert_equal now, history.changed_at
  end

  def test_history_detail_values_on_create_root
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
    result = BxResourceService.new(form).create_root!
    history = BxHistory.where(:target => "resource", :source_id => result.data.id).first
    code_detail = history.details.detect { |detail| detail.property == "code" }
    assert_not_nil code_detail
    assert_equal "", code_detail.old_value
    assert_equal "test", code_detail.new_value
    summary_detail = history.details.detect { |detail| detail.property == "summary" }
    assert_not_nil summary_detail
    assert_equal "", summary_detail.old_value
    assert_equal "summary", summary_detail.new_value
  end

  def test_relational_issue_registration_on_create_root
    assert_difference("BxHistoryIssue.count", 2) do
      form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project, :relational_issues => "1,3")
      BxResourceService.new(form).create_root!
    end
  end

  def test_relational_issue_id_on_create_root
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project, :relational_issues => "1,3")
    result = BxResourceService.new(form).create_root!
    history = BxHistory.where(:target => "resource", :source_id => result.data.id).first
    assert history.issues.any? { |issue| issue.id == 1 }
    assert history.issues.any? { |issue| issue.id == 3 }
  end

  def test_branch_registration_on_add_branch
    assert_difference("BxResourceBranch.count") do
      resource = BxResourceNode.find(1)
      form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :root_node_id => resource.id)
      result = BxResourceService.new(form).add_branch!
      assert result.success?
    end
  end

  def test_branch_not_registration_on_add_branch_by_invalid_form
    assert_no_difference("BxResourceBranch.count") do
      resource = BxResourceNode.find(1)
      form = BxResourceBranchForm.new(:code => "", :name => "branch_name", :root_node_id => resource.id)
      result = BxResourceService.new(form).add_branch!
      assert result.invalid_input?
    end
  end

  def test_registered_branch_values_on_add_branch
    resource = BxResourceNode.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :root_node_id => resource.id)
    result = BxResourceService.new(form).add_branch!
    branch = BxResourceBranch.where(:code => "branch_test", :root_node_id => resource.id).first
    assert_not_nil branch
    assert_equal "branch_name", branch.name
  end

  def test_history_values_on_add_branch
    now = Time.now
    Time.stubs(:now).returns(now)
    resource = BxResourceNode.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :root_node_id => resource.id)
    result = BxResourceService.new(form).add_branch!
    history = BxHistory.where(:target => "resource", :source_id => resource.id).last
    assert_equal "create", history.operation_type
    assert_equal "create_branch", history.operation
    assert_equal 1, history.changed_by
    assert_equal now, history.changed_at
  end

  def test_history_detail_values_on_add_branch
    resource = BxResourceNode.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :root_node_id => resource.id)
    result = BxResourceService.new(form).add_branch!
    history = BxHistory.where(:target => "resource", :source_id => resource.id).last
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
      resource = BxResourceNode.find(1)
      form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :root_node_id => resource.id, :relational_issues => "1,3")
      BxResourceService.new(form).add_branch!
    end
  end

  def test_relational_issue_id_on_add_branch
    resource = BxResourceNode.find(1)
    form = BxResourceBranchForm.new(:code => "branch_test", :name => "branch_name", :root_node_id => resource.id, :relational_issues => "1,3")
    result = BxResourceService.new(form).add_branch!
    history = BxHistory.where(:target => "resource", :source_id => resource.id).first
    assert history.issues.any? { |issue| issue.id == 1 }
    assert history.issues.any? { |issue| issue.id == 3 }
  end
end

