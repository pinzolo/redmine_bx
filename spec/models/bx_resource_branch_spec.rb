# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceBranch do
  fixtures :projects, :bx_resource_categories, :bx_resource_branches, :bx_resource_nodes, :bx_resource_values

  describe "#category" do
    it "returns belonging category" do
      expected = BxResourceCategory.find(1)
      expect(BxResourceBranch.find(1).category).to eq expected
    end
  end
end

