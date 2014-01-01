# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceValue do
  fixtures :projects, :bx_resource_nodes, :bx_resource_values
  let(:resource_value) { BxResourceValue.find(1) }

  describe "#resource" do
    it "returns belonging resource" do
      expected = BxResourceNode.find(4)
      expect(resource_value.resource).to eq expected
    end
  end

  describe "#branch" do
    it "returns belonging branch" do
      expected = BxResourceBranch.find(2)
      expect(resource_value.branch).to eq expected
    end
  end
end
