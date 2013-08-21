# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class BxResourceServiceTest < ActiveSupport::TestCase
  fixtures :projects

  def test_create_root_success
    count = BxResourceNode.count
    prj = Project.all.first
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => prj)
    result = BxResourceService.new(form).create_root!
    assert result.success?
    assert_equal count + 1, BxResourceNode.count
  end

  def test_create_root_saving_root_node
    prj = Project.all.first
    form = BxRootResourceForm.new(:resource_code => "test", :resource_summary => "summary", :project => prj)
    result = BxResourceService.new(form).create_root!
    assert result.success?
    node = BxResourceNode.where(:project_id => prj.id, :code => "test").first
    assert node.root?
    assert_equal node.root_node_id, node.id
  end
end

