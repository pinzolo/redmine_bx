# coding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class BxResourceBranchTest < ActiveSupport::TestCase
  fixtures :bx_resource_nodes, :bx_resource_branches

  def test_changesets_has_attribute_value_that_assigned_by_evacuatable_method
    branch = BxResourceBranch.new(:root_node_id => 1, :name => "test branch", :code => "test")
    branch.save
    assert branch.changesets.key?(:name)
  end

  def test_changesets_not_have_attribute_value_that_not_assigned_by_evacuatable_method
    branch = BxResourceBranch.new(:root_node_id => 1, :name => "test branch", :code => "test")
    branch.save
    assert_equal false, branch.changesets.key?(:root_node_id)
  end

  def test_changesets_returns_emtpy_old_value_on_create
    branch = BxResourceBranch.new(:root_node_id => 1, :name => "test branch", :code => "test")
    branch.save
    assert_equal "", branch.changesets[:name].first
  end

  def test_changesets_returns_new_value_on_create
    branch = BxResourceBranch.new(:root_node_id => 1, :name => "test branch", :code => "test")
    branch.save
    assert_equal "test", branch.changesets[:code].last
  end

  def test_changesets_returns_old_value_on_update
    branch = BxResourceBranch.find(1)
    branch.update_attributes(:name => "Chinese", :code => "cn")
    assert_equal "Japanese", branch.changesets[:name].first
  end

  def test_changesets_returns_new_value_on_update
    branch = BxResourceBranch.find(1)
    branch.update_attributes(:name => "Chinese", :code => "cn")
    assert_equal "cn", branch.changesets[:code].last
  end
end
