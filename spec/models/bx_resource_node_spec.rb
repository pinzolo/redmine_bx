# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceNode do
  fixtures :projects, :bx_resource_nodes, :bx_resource_branches, :bx_resource_values

  describe "#depth" do
    context "when node is root" do
      it "equals 1" do
        expect(BxResourceNode.find(1).depth).to eq 1
      end
    end

    context "when node is not root" do
      it "equals parent depth + 1" do
        expect(BxResourceNode.find(9).depth).to eq 3
      end
    end
  end

  describe "#ancestry" do
    context "when node is root" do
      let (:node) { BxResourceNode.find(1) }
      it "returns array that conains self only" do
        expect(node.ancestry).to eq [node]
      end
    end
    context "when node is not root" do
      let(:node) { BxResourceNode.find(9) }
      it "returns array of BxResourceNode" do
        expect(node.ancestry.all? { |n| n.is_a?(BxResourceNode) }).to eq true
      end
      it "returns array that conains ancestors of node(contains self)" do
        expect(node.ancestry.map(&:id)).to eq [7, 8, 9]
      end
    end
  end

  describe "#descendants" do
    it "returns descendant nodes" do
      expect(BxResourceNode.find(8).descendants.map(&:id)).to eq [12, 14, 13, 9, 11, 10]
    end
  end

  describe "#value" do
    context "when node has value" do
      let(:node) { BxResourceNode.find(4) }
      context "when argument is BxResourceBranch" do
        it "returns value that branch_id equals to id of argument" do
          expect(node.value(BxResourceBranch.find(2))).to eq "Resources"
        end
      end
      context "when argument is Integer" do
        it "returns value that branch_id equals to argument" do
          expect(node.value(2)).to eq "Resources"
        end
      end
      context "when argument is String" do
        it "returns value that branch_id equals to Integer expression of argument" do
          expect(node.value("2")).to eq "Resources"
        end
      end
    end
  end
end
