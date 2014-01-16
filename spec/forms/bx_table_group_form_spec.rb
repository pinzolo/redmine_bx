# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxTableGroupForm do
  fixtures :bx_databases, :bx_data_types

  describe "validation" do
    let(:form) { BxTableGroupForm.new(:name => "test", :database_id => 1, :data_types => [1, 2, 3]) }

    describe "#name" do# {{{
      context "when nil" do
        it "form is invalid" do
          form.name = nil
          expect(form.valid?).to eq false
        end
      end
      context "when empty" do
        it "form is invalid" do
          form.name = ""
          expect(form.valid?).to eq false
        end
      end
      context "when blank" do
        it "form is invalid" do
          form.name = "   "
          expect(form.valid?).to eq false
        end
      end
      context "when length is 1" do
        it "form is valid" do
          form.name = "a"
          expect(form.valid?).to eq true
        end
      end
      context "when length is 200" do
        it "form is valid" do
          form.name = "a" * 200
          expect(form.valid?).to eq true
        end
      end
      context "when length is 201" do
        it "form is invalid" do
          form.name = "a" * 201
          expect(form.valid?).to eq false
        end
      end
    end# }}}

    describe "#database_id" do# {{{
      context "when nil" do
        it "form is invalid" do
          form.database_id = nil
          expect(form.valid?).to eq false
        end
      end
      context "when empty" do
        it "form is invalid" do
          form.database_id = ""
          expect(form.valid?).to eq false
        end
      end
      context "when blank" do
        it "form is invalid" do
          form.database_id = "   "
          expect(form.valid?).to eq false
        end
      end
      context "when other value" do
        it "form is valid" do
          expect(form.valid?).to eq true
        end
      end
    end# }}}

    describe "#data_types" do# {{{
      context "when nil" do
        it "form is invalid" do
          form.data_types = nil
          expect(form.valid?).to eq false
        end
      end
      context "when empty array" do
        it "form is invalid" do
          form.data_types = []
          expect(form.valid?).to eq false
        end
      end
      context "when other value" do
        it "form is valid" do
          expect(form.valid?).to eq true
        end
      end
    end# }}}
  end
end
