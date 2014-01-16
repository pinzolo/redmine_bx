# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxTableGroupForm do
  fixtures :bx_table_defs

  describe "validation" do
    let(:form) { BxTableDefForm.new(:physical_name => "members", :logical_name => "Members of service") }

    describe "#physical_name" do# {{{
      context "when nil" do
        it "form is invalid" do
          form.physical_name = nil
          expect(form.valid?).to eq false
        end
      end
      context "when empty" do
        it "form is invalid" do
          form.physical_name = ""
          expect(form.valid?).to eq false
        end
      end
      context "when blank" do
        it "form is invalid" do
          form.physical_name = "   "
          expect(form.valid?).to eq false
        end
      end
      context "when length is 1" do
        it "form is valid" do
          form.physical_name = "a"
          expect(form.valid?).to eq true
        end
      end
      context "when length is 200" do
        it "form is valid" do
          form.physical_name = "a" * 200
          expect(form.valid?).to eq true
        end
      end
      context "when length is 201" do
        it "form is invalid" do
          form.physical_name = "a" * 201
          expect(form.valid?).to eq false
        end
      end
      context "when already exists in table_defs" do
        context "on create" do
          it { pending }
        end
        context "on update" do
          context "same name record is base record" do
            it { pending }
          end
            context "same name record is not base record" do
            it { pending }
          end
        end

      end
    end# }}}

    describe "#logical_name" do# {{{
      context "when nil" do
        it "form is valid" do
          form.logical_name = nil
          expect(form.valid?).to eq true
        end
      end
      context "when empty" do
        it "form is valid" do
          form.logical_name = ""
          expect(form.valid?).to eq true
        end
      end
      context "when blank" do
        it "form is valid" do
          form.logical_name = "   "
          expect(form.valid?).to eq true
        end
      end
      context "when length is 1" do
        it "form is valid" do
          form.logical_name = "a"
          expect(form.valid?).to eq true
        end
      end
      context "when length is 200" do
        it "form is valid" do
          form.logical_name = "a" * 200
          expect(form.valid?).to eq true
        end
      end
      context "when length is 201" do
        it "form is invalid" do
          form.logical_name = "a" * 201
          expect(form.valid?).to eq false
        end
      end
    end# }}}
  end
end

