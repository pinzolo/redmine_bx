# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceCategoryForm do
  describe "validation" do
    let(:form) { BxResourceCategoryForm.new }

    describe "#name" do
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
    end
  end
end

