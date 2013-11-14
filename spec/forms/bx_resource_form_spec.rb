# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceForm do
  fixtures :projects, :bx_resource_categories, :bx_resource_branches, :bx_resource_nodes, :bx_resource_values

  describe "#initialize" do
    context "when given integer as parent_id" do
      let(:form) { BxResourceForm.new(:parent_id => 1) }

      it "assigns category_id of parent" do
        parent = BxResourceNode.find(1)
        expect(form.category_id).to eq parent.category_id
      end
      it "assigns branches of parent category" do
        expected = BxResourceNode.find(1).category.branches
        expect(form.branches).to eq expected
      end
    end
    context "when given string as parent_id" do
      let(:form) { BxResourceForm.new(:parent_id => "1") }

      it "assigns category_id of parent" do
        parent = BxResourceNode.find(1)
        expect(form.category_id).to eq parent.category_id
      end
      it "assigns branches of parent category" do
        expected = BxResourceNode.find(1).category.branches
        expect(form.branches).to eq expected
      end
    end
    context "when given nil as parent_id" do
      let(:form) { BxResourceForm.new }

      it "category_id is not assigned" do
        expect(form.category_id).to eq nil
      end
      it "branches is not assigned" do
        expect(form.branches).to eq nil
      end
    end
    context "when given not exist id as parent_id" do
      let(:form) { BxResourceForm.new(:parent_id => 100) }

      it "category_id is not assigned" do
        expect(form.category_id).to eq nil
      end
      it "branches is not assigned" do
        expect(form.branches).to eq nil
      end
    end
  end

  describe "validation" do
    let(:form) { BxResourceForm.new(:project_id =>  1, :parent_id => 3, :code => "bar") }

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
      context "when base_resource is nil" do
        before { form.base_resource = nil }

        context "when already exists" do
          it "form is invalid" do
            form.code = "new_resource"
            expect(form.valid?).to eq false
          end
        end
      end
      context "when base_resource is not nil" do
        before { form.base_resource = BxResourceNode.find(5) }

        context "when code equals to base_resource's code" do
          it "form is valid" do
            form.code = "new_resource"
            expect(form.valid?).to eq true
          end
        end
        context "when code equals to other resource's code" do
          it "form is invalid" do
            form.code = "resources"
            expect(form.valid?).to eq false
          end
        end
      end
    end

    describe "#summary" do
      context "when nil" do
        it "form is valid" do
          form.summary = nil
          expect(form.valid?).to eq true
        end
      end
      context "when empty" do
        it "form is valid" do
          form.summary = ""
          expect(form.valid?).to eq true
        end
      end
      context "when blank" do
        it "form is valid" do
          form.summary = "   "
          expect(form.valid?).to eq true
        end
      end
      context "when length is 1" do
        it "form is valid" do
          form.summary = "a"
          expect(form.valid?).to eq true
        end
      end
      context "when length is 200" do
        it "form is valid" do
          form.summary = "a" * 200
          expect(form.valid?).to eq true
        end
      end
      context "when length is 201" do
        it "form is invalid" do
          form.summary = "a" * 201
          expect(form.valid?).to eq false
        end
      end
    end
  end
end

