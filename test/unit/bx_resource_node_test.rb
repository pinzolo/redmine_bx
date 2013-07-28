# coding: utf-8
require File.expand_path('../../test_helper', __FILE__)

class BxResourceNodeTest < ActiveSupport::TestCase
  fixtures :projects, :bx_resource_nodes

  # Replace this with your real tests.
  def test_roots_by_project_id
    roots = BxResourceNode.roots(1)
    assert_equal 2, roots.length
  end

  def test_roots_by_project_instance
    roots = BxResourceNode.roots(Project.find(1))
    assert_equal 2, roots.length
  end
end
