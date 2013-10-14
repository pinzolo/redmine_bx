# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceNode do
  fixtures :projects, :bx_resource_nodes, :bx_resource_branches, :bx_resource_values

  describe "#depth" do

    context "when node is root" do
      before(:each) do
        @node = BxResourceNode.find(1)
      end

      it "equals 1" do
        expect(@node.depth).to eq 1
      end
    end

    context "when node is not root" do
      before(:each) do
        @node = BxResourceNode.find(10)
      end

      it "equals parent depth + 1" do
        expect(@node.depth).to eq 3
      end
    end
  end

  describe "#ancestry" do
  end
end
