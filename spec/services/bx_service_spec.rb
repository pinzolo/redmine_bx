# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestForm
  def initialize(flag)
    @flag = flag
  end

  def valid?
    @flag
  end
end
class TestService
  include BxService

  def do_something
    "something"
  end

  def raise_error
    raise "error"
  end

  def raise_conflict
    raise ActiveRecord::StaleObjectError.new("action", "record")
  end
end

describe BxService do
  context "when is included" do
    let(:service) { TestService.new }

    it "can call original method" do
      expect(service.do_something).to eq "something"
    end
    it "can call transaction method" do
      expect(service).to respond_to(:do_something!)
      expect(service).to respond_to(:raise_error!)
      expect(service).to respond_to(:raise_conflict!)
    end
  end
  describe "transaction method" do
    it "returns BxServiceResult" do
      expect(TestService.new.do_something!).to be_an_instance_of(BxServiceResult)
    end

    context "when method succeed" do
      let(:result) { TestService.new.do_something! }
      it "result is success" do
        expect(result.success?).to eq true
      end
      it "result data is return value" do
        expect(result.data).to eq "something"
      end
    end
    context "when method failed" do
      context "by invalid input" do
        let(:result) { TestService.new(TestForm.new(false)).do_something! }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is invalid_input" do
          expect(result.invalid_input?).to eq true
        end
        it "result data is nil" do
          expect(result.data).to eq nil
        end
      end
      context "by error raised" do
        let(:result) { TestService.new(TestForm.new(true)).raise_error! }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is error" do
          expect(result.error?).to eq true
        end
        it "result data is raised error object" do
          expect(result.data).to be_a(StandardError)
        end
      end
      context "by conflict raised" do
        let(:result) { TestService.new(TestForm.new(true)).raise_conflict! }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is conflict" do
          expect(result.conflict?).to eq true
        end
        it "result data is raised error object" do
          expect(result.data).to be_an_instance_of(ActiveRecord::StaleObjectError)
        end
      end
    end
  end
end
