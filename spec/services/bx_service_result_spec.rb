# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxServiceResult do
  describe "#success?" do
    context "when reason is nil on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(nil, "test").success?).to eq true
      end
    end
    context "when reason is :conflict on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:conflict, "test").success?).to eq false
      end
    end
    context "when reason is :error on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:error, "test").success?).to eq false
      end
    end
    context "when reason is :invalid_input on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:invalid_input, "test").success?).to eq false
      end
    end
    context "when reason is :test(other value) on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:test, "test").success?).to eq false
      end
    end
  end
  describe "#failure?" do
    context "when reason is nil on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(nil, "test").failure?).to eq false
      end
    end
    context "when reason is :conflict on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(:conflict, "test").failure?).to eq true
      end
    end
    context "when reason is :error on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(:error, "test").failure?).to eq true
      end
    end
    context "when reason is :invalid_input on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(:invalid_input, "test").failure?).to eq true
      end
    end
    context "when reason is :test(other value) on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(:test, "test").failure?).to eq true
      end
    end
  end
  describe "#conflict?" do
    context "when reason is nil on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(nil, "test").conflict?).to eq false
      end
    end
    context "when reason is :conflict on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(:conflict, "test").conflict?).to eq true
      end
    end
    context "when reason is :error on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:error, "test").conflict?).to eq false
      end
    end
    context "when reason is :invalid_input on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:invalid_input, "test").conflict?).to eq false
      end
    end
    context "when reason is :test(other value) on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:test, "test").conflict?).to eq false
      end
    end
  end
  describe "#error?" do
    context "when reason is nil on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(nil, "test").error?).to eq false
      end
    end
    context "when reason is :conflict on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:conflict, "test").error?).to eq false
      end
    end
    context "when reason is :error on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(:error, "test").error?).to eq true
      end
    end
    context "when reason is :invalid_input on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:invalid_input, "test").error?).to eq false
      end
    end
    context "when reason is :test(other value) on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:test, "test").error?).to eq false
      end
    end
  end
  describe "#invalid_input?" do
    context "when reason is nil on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(nil, "test").invalid_input?).to eq false
      end
    end
    context "when reason is :conflict on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:conflict, "test").invalid_input?).to eq false
      end
    end
    context "when reason is :error on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:error, "test").invalid_input?).to eq false
      end
    end
    context "when reason is :invalid_input on initialized" do
      it "returns true" do
        expect(BxServiceResult.new(:invalid_input, "test").invalid_input?).to eq true
      end
    end
    context "when reason is :test(other value) on initialized" do
      it "returns false" do
        expect(BxServiceResult.new(:test, "test").invalid_input?).to eq false
      end
    end
  end
  describe "#data" do
    it "returns given value on initialized" do
      expect(BxServiceResult.new(nil, "test").data).to eq "test"
    end
  end
end
