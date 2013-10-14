# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxTemplate do
  describe ".available_target?" do
    context "when given 'resource'" do
      it "returns true" do
        expect(BxTemplate.available_target?("resource")).to eq true
      end
    end
    context "when given 'table_def'" do
      it "returns true" do
        expect(BxTemplate.available_target?("table_def")).to eq true
      end
    end
    context "when given 'RESOURCE'" do
      it "returns false" do
        expect(BxTemplate.available_target?("RESOURCE")).to eq false
      end
    end
    context "when given 'TABLE_DEF'" do
      it "returns false" do
        expect(BxTemplate.available_target?("TABLE_DEF")).to eq false
      end
    end
    context "when given other String" do
      it "returns false" do
        expect(BxTemplate.available_target?("other")).to eq false
      end
    end
  end
end

