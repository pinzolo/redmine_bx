# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxValuesNumericalityValidator do
  before do
    class TestClassWithoutOption
      include ActiveModel::Conversion
      include ActiveModel::Validations
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      attr_accessor :values

      validates :values, :bx_values_numericality => true
    end

    class TestClassWithOption
      include ActiveModel::Conversion
      include ActiveModel::Validations
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      attr_accessor :values

      validates :values, :bx_values_numericality => { :ignore_blank => true }
    end
  end

  describe "#validate_each" do
    context "without option" do
      before(:each) do
        @model = TestClassWithoutOption.new
      end

      context "when values is nil" do
        before do
          @model.values = nil
        end

        it "model is valid" do
          expect(@model.valid?).to eq true
        end
      end

      context "when values have only nil" do
        before do
          @model.values = [nil, nil, nil]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "when values are numeric Strings" do
        before do
          @model.values = [ "1", "2", "3" ]
        end

        it "model is valid" do
          expect(@model.valid?).to eq true
        end
      end

      context "when values have not numeric String" do
        before do
          @model.values = [ "1", "2", "a" ]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "when values is Hash" do
        before do
          @model.values = { :a => "1", :b => "2", :c => "3" }
        end

        it "apply to values of Hash" do
          expect(@model.valid?).to eq true
        end
      end

      context "when values contain nil" do
        before do
          @model.values = [ "1", "3", nil ]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "when values contain empty" do
        before do
          @model.values = [ "1", "3", "" ]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "when values contain blank" do
        before do
          @model.values = [ "1", "3", " " ]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end
    end

    context "with ignore_blank option" do
      before(:each) do
        @model = TestClassWithOption.new
      end

      describe "same behavior with no option" do
        context "when values is nil" do
          before do
            @model.values = nil
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end

        context "when values are numeric Strings" do
          before do
            @model.values = [ "1", "2", "3" ]
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end

        context "when values have not numeric String" do
          before do
            @model.values = [ "1", "2", "a" ]
          end

          it "model is invalid" do
            expect(@model.valid?).to eq false
          end
        end

        context "when values is Hash" do
          before do
            @model.values = { :a => "1", :b => "2", :c => "3" }
          end

          it "apply to values of Hash" do
            expect(@model.valid?).to eq true
          end
        end
      end

      context "when values have only nil" do
        before do
          @model.values = [nil, nil, nil]
        end

        it "model is valid" do
          expect(@model.valid?).to eq true
        end
      end

      context "when values contain nil" do
        before do
          @model.values = [ "1", "3", nil ]
        end

        it "model is valid" do
          expect(@model.valid?).to eq true
        end
      end

      context "when values contain empty" do
        before do
          @model.values = [ "1", "3", "" ]
        end

        it "model is valid" do
          expect(@model.valid?).to eq true
        end
      end

      context "when values contain blank" do
        before do
          @model.values = [ "1", "3", " " ]
        end

        it "model is valid" do
          expect(@model.valid?).to eq true
        end
      end
    end
  end

  describe "error message" do
    before(:each) do
      @model = TestClassWithoutOption.new
      @model.values = ["1", "a"]
    end

    it "errors contains :values key" do
      if @model.valid?
        fail("model should be invalid")
      else
        expect(@model.errors.messages.key?(:values)).to eq true
      end
    end

    it "error message is 'Values contains not number'" do
      if @model.valid?
        fail("model should be invalid")
      else
        expect(@model.errors.full_messages.first).to eq "Values contains not number"
      end
    end
  end
end
