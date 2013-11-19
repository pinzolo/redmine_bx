# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceCategory do
  fixtures :projects, :bx_resource_categories, :bx_resource_branches, :bx_resource_nodes, :bx_resource_values,
           :bx_histories, :bx_history_details

  let(:category) { BxResourceCategory.find(1) }

  describe "#resources" do
    it "returns resource nodes that category_id is self and prent_id is 0 and ordered by default_path attribute" do
      expected = BxResourceNode.where(:category_id => category.id, :parent_id => 0).order(:default_path).to_a
      expect(category.resources.to_a).to eq expected
    end
  end

  describe "#all_resources" do
    it "returns resource nodes that category_id is self id and orderd by default_path attribute" do
      expected = BxResourceNode.where(:category_id => category.id).order(:default_path).to_a
      expect(category.all_resources.to_a).to eq expected
    end
  end

  describe "#histories" do
    it "returns histories that source_id is self and target is 'resource_category' and orderd by changed_at" do
      expected = BxHistory.where(:source_id => category.id, :target => "resource_category").order(:changed_at).to_a
      expect(category.histories.to_a).to eq expected
    end
  end
end

