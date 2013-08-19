# coding: utf-8
require File.expand_path('../../../test_helper', __FILE__)

class IssuesRelTest
  include BxIssuesRelation
end

class BxIssuesRelationTest < ActiveSupport::TestCase
  fixtures :issues

  def setup
    @rel = IssuesRelTest.new
  end

  def test_accessor_defined
    assert @rel.respond_to?(:relational_issues)
  end

  def test_relational_issue_ids
    @rel.relational_issues = "#1,13 aaa #11  5, 100"
    ids = @rel.relational_issue_ids
    assert_equal 4, ids.length
    assert_equal 1, ids[0]
    assert_equal 5, ids[1]
    assert_equal 11, ids[2]
    assert_equal 13, ids[3]
  end
end
