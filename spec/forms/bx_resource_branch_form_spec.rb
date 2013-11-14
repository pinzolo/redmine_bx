# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceBranchForm do
  describe "validation" do
    let(:form) { BxResourceBranchForm.new(:category_id => 1, :name => "foo", :code => "bar") }

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

    describe "#code" do
      context "when nil" do
        it "form is invalid" do
          form.code = nil
          expect(form.valid?).to eq false
        end
      end
      context "when empty" do
        it "form is invalid" do
          form.code = ""
          expect(form.valid?).to eq false
        end
      end
      context "when blank" do
        it "form is invalid" do
          form.code = "   "
          expect(form.valid?).to eq false
        end
      end
      context "when length is 1" do
        it "form is valid" do
          form.code = "a"
          expect(form.valid?).to eq true
        end
      end
      context "when length is 200" do
        it "form is valid" do
          form.code = "a" * 200
          expect(form.valid?).to eq true
        end
      end
      context "when length is 201" do
        it "form is invalid" do
          form.code = "a" * 201
          expect(form.valid?).to eq false
        end
      end
      context "when base_branch is nil" do
        before { form.base_branch = nil }

        context "when already exists" do
          it "form is invalid" do
            form.code = "ja"
            expect(form.valid?).to eq false
          end
        end
      end
      context "when bas_branch is not nil" do
        before { form.base_branch = BxResourceBranch.find(1) }

        context "when code equals to base_branch's code" do
          it "form is valid" do
            form.code = "ja"
            expect(form.valid?).to eq true
          end
        end
        context "when code equals to other branch's code" do
          it "form is invalid" do
            form.code = "en"
            expect(form.valid?).to eq false
          end
        end
      end
    end
  end
end


