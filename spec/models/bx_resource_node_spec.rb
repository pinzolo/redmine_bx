# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceNode do
  fixtures :projects, :bx_resource_categories, :bx_resource_nodes, :bx_resource_branches, :bx_resource_values,
           :bx_histories, :bx_history_details

  describe "#project" do
    it "returns belonging project" do
      expected = Project.find(1)
      expect(BxResourceNode.find(1).project).to eq expected
    end
  end

  describe "#parent" do
    context "when node is root" do
      it "returns nil" do
        expect(BxResourceNode.find(1).parent).to eq nil
      end
    end
    context "when node is not root" do
      it "returns parent resource" do
        expected = BxResourceNode.find(1)
        expect(BxResourceNode.find(3).parent).to eq expected
      end
    end
  end

  describe "#category" do
    it "returns belonging category" do
      expected = BxResourceCategory.find(1)
      expect(BxResourceNode.find(1).category).to eq expected
    end
  end

  describe "#children" do
    it "returns resource nods that parent_id is self and orderd by code" do
      expected = BxResourceNode.where(:parent_id => 1).order(:code).to_a
      expect(BxResourceNode.find(1).children.to_a).to eq expected
    end
  end

  describe "#values" do
    it "returns BxResourceValue list that resource_id is self" do
      expected = BxResourceValue.where(:node_id => 1).to_a
      expect(BxResourceNode.find(1).values.to_a).to eq expected
    end
  end

  describe "#histories" do
    it "returns histories that source_id is self and target is 'resource' and orderd by changed_at" do
      expected = BxHistory.where(:source_id => 1, :target => "resource").order(:changed_at).to_a
      expect(BxResourceNode.find(1).histories.to_a).to eq expected
    end
  end

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
    context "when node doesn't have value" do
      let(:node) { BxResourceNode.find(9) }

      context "when argument is BxResourceBranch" do
        it "returns nil" do
          expect(node.value(BxResourceBranch.find(2))).to eq nil
        end
      end
      context "when argument is Integer" do
        it "returns nil" do
          expect(node.value(2)).to eq nil
        end
      end
      context "when argument is String" do
        it "returns nil" do
          expect(node.value("2")).to eq nil
        end
      end
    end
  end

  describe "#default_path" do
    context "when created" do
      context "when node is root" do
        it "set self code" do
          node = BxResourceNode.create(:project_id => 1, :category_id => 1, :code => "new_root", :summary => "summary", :default_path => "foo")
          expect(node.default_path).to eq "new_root"
        end
      end
      context "when node is not root" do
        it "set joined code by ':'" do
          node = BxResourceNode.create(:project_id => 1, :parent_id => 5, :category_id => 1, :code => "new_root", :summary => "summary", :default_path => "foo")
          expect(node.default_path).to eq "text:label:new_resource:new_root"
        end
      end
    end
    context "when updated" do
      context "when node is root" do
        it "set self code" do
          node = BxResourceNode.find(1)
          node.update_attributes(:code => "bar", :default_path => "foo")
          expect(node.default_path).to eq "bar"
        end
      end
      context "when node is not root" do
        it "set joined code by ':'" do
          node = BxResourceNode.find(5)
          node.update_attributes(:code => "bar", :default_path => "foo")
          expect(node.default_path).to eq "text:label:bar"
        end
      end
    end
  end

  describe "#path" do
    let(:node) { BxResourceNode.find(9) }
    context "when argument not given" do
      it "returns default_path" do
        expect(node.path).to eq node.default_path
      end
    end
    context "when argument is nil" do
      it "returns default_path" do
        expect(node.path(nil)).to eq node.default_path
      end
    end
    context "when argument is empty" do
      it "returns default_path" do
        expect(node.path("")).to eq node.default_path
      end
    end
    context "when argument is blank" do
      it "returns path string that joined by argument" do
        expect(node.path("  ")).to eq "activemodel  attributes  bx_resource_form"
      end
    end
    context "when argument is string" do
      it "returns path string that joined by argument" do
        expect(node.path(".")).to eq "activemodel.attributes.bx_resource_form"
      end
    end
  end
end
