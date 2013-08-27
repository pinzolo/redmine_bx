# coding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class BxResourceNodeTest < ActiveSupport::TestCase
  fixtures :projects, :bx_resource_nodes, :bx_resource_branches, :bx_resource_values

  def test_root_node_is_not_leaf
    node = BxResourceNode.find(1)
    assert_equal false, node.leaf?
  end

  def test_node_not_having_values_is_not_leaf
    node = BxResourceNode.find(9)
    assert_equal false, node.leaf?
  end

  def test_node_having_values_is_leaf
    node = BxResourceNode.find(11)
    assert node.leaf?
  end

  def test_ancestry_of_root_node_on_include_self
    node = BxResourceNode.find(1)
    assert_equal 1, node.ancestry.length
    assert_equal node, node.ancestry.first
  end

  def test_ancestry_of_root_node_on_not_include_self
    node = BxResourceNode.find(1)
    assert_equal 0, node.ancestry(false).length
  end

  def test_ancestry_of_not_root_node_on_include_self
    node = BxResourceNode.find(5)
    ancestry = node.ancestry
    assert_equal 3, ancestry.length
    assert_equal node.parent.parent, ancestry[0]
    assert_equal node.parent, ancestry[1]
    assert_equal node, ancestry[2]
  end

  def test_ancestry_of_root_node_on_not_include_self
    node = BxResourceNode.find(5)
    ancestry = node.ancestry(false)
    assert_equal 2, ancestry.length
    assert_equal node.parent.parent, ancestry[0]
    assert_equal node.parent, ancestry[1]
  end

  def test_depth_of_root
    node = BxResourceNode.find(1)
    assert_equal 0, node.depth
  end

  def test_depth_of_not_root
    node = BxResourceNode.find(10)
    assert_equal 2, node.depth
  end

  def test_root_path_is_blank_only_on_not_include_self
    node = BxResourceNode.find(1)
    assert_equal "locales", node.path(":")
  end

  def test_path_on_delimiter_is_period
    node = BxResourceNode.find(10)
    assert_equal "activemodel.attributes.bx_root_resource_form", node.path(".")
  end

  def test_path_on_delimiter_is_colon
    node = BxResourceNode.find(10)
    assert_equal "activemodel:attributes:bx_root_resource_form", node.path(":")
  end
end
