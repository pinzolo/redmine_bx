# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxValuesOrderingValidator do
  before do
    class TestClassWithoutOption
      include ActiveModel::Conversion
      include ActiveModel::Validations
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      attr_accessor :values

      validates :values, :bx_values_ordering => true
    end

    class TestClassWithOption
      include ActiveModel::Conversion
      include ActiveModel::Validations
      extend ActiveModel::Naming
      extend ActiveModel::Translation

      attr_accessor :values

      validates :values, :bx_values_ordering => { :ignore_blank => true }
    end
  end

  describe "#validate_each" do
    context "without option" do
      before(:each) do
        @model = TestClassWithoutOption.new
      end

      context "values is nil" do
        before do
          @model.values = nil
        end

        it "model is valid" do
          expect(@model.valid?).to eq true
        end
      end

      context "values have only nil" do
        before do
          @model.values = [nil, nil, nil]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "values are valid as order" do
        context "Integer array" do
          before do
            @model.values = [1, 3, 2]
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end

        context "String array" do
          before do
            @model.values = ["1", "3", "2"]
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end
      end

      context "values is are invalid as order" do
        before do
          @model.values = [1, 2, 4]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "values is Hash" do
        before do
          @model.values = { :a => 1, :b => 3, :c => 2 }
        end

        it "apply to values of Hash" do
          expect(@model.valid?).to eq true
        end
      end

      context "values contain invalid character" do
        before do
          @model.values = ["1", "2", "c"]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "values contain nil" do
        before do
          @model.values = [1, 2, nil, 4]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end

      context "values contain empty String" do
        before do
          @model.values = ["1", "2", "", "3"]
        end

        it "model is invalid" do
          expect(@model.valid?).to eq false
        end
      end
    end

    context "with option" do
      before(:each) do
        @model = TestClassWithOption.new
      end

      describe "same behavior with no option" do
        context "values is nil" do
          before do
            @model.values = nil
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end

        context "values are valid as order" do
          context "Integer array" do
            before do
              @model.values = [1, 3, 2]
            end

            it "model is valid" do
              expect(@model.valid?).to eq true
            end
          end

          context "String array" do
            before do
              @model.values = ["1", "3", "2"]
            end

            it "model is valid" do
              expect(@model.valid?).to eq true
            end
          end
        end

        context "values is are invalid as order" do
          before do
            @model.values = [1, 2, 4]
          end

          it "model is invalid" do
            expect(@model.valid?).to eq false
          end
        end

        context "values is Hash" do
          before do
            @model.values = { :a => 1, :b => 3, :c => 2 }
          end

          it "apply to values of Hash" do
            expect(@model.valid?).to eq true
          end
        end

        context "values contain invalid character" do
          before do
            @model.values = ["1", "2", "c"]
          end

          it "model is invalid" do
            expect(@model.valid?).to eq false
          end
        end
      end

      context "values contain nil or blank" do
        context "values have all nil or blank" do
          before do
            @model.values = [nil, ""]
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end

        context "values is Array" do
          before do
            @model.values = ["1", "", nil]
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end

        context "values is Hash" do
          before do
            @model.values = { :a => "1", :b => "", :c => nil }
          end

          it "model is valid" do
            expect(@model.valid?).to eq true
          end
        end
      end
    end
  end

  describe "error message" do
    before(:each) do
      @model = TestClassWithoutOption.new
      @model.values = [1, 3]
    end

    it "errors contains :values key" do
      if @model.valid?
        fail("model should be invalid")
      else
        expect(@model.errors.messages.key?(:values)).to eq true
      end
    end

    it "error message is 'Values are invalid as order'" do
      if @model.valid?
        fail("model should be invalid")
      else
        expect(@model.errors.full_messages.first).to eq "Values are invalid as order"
      end
    end
  end
end
