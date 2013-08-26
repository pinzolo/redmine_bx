# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxResourceServiceTest < ActiveSupport::TestCase
  fixtures :projects, :issues, :users

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
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
    result = BxResourceService.new(form).create_root!
    history = BxHistory.where(:target => "resource", :source_id => result.data.id).first
    assert_equal "create", history.operation_type
    assert_equal "create_root", history.operation
    assert_equal result.data.id, history.source_id
    assert_equal 1, history.changed_by
  end

  def test_history_detail_values_on_create_root
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => @project)
    result = BxResourceService.new(form).create_root!
    history = BxHistory.where(:target => "resource", :source_id => result.data.id).first
    assert history.details.any? { |detail| detail.property == "summary"}
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
end

