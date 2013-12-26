# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceService do
  fixtures :projects, :issues, :users, :bx_resource_nodes, :bx_resource_branches, :bx_resource_values, :bx_resource_categories
  before { User.current = User.find(1) }
  let(:project) { Project.all.first }

  describe "#create_category!" do
    context "when input is valid" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "test_desc", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 1 category" do
          expect { service.create_category! }.to change { BxResourceCategory.count }.by(1)
        end
        it "create 1 history" do
          expect { service.create_category! }.to change { BxHistory.count }.by(1)
        end
        it "create 2 history details" do
          expect { service.create_category! }.to change { BxHistoryDetail.count }.by(2)
        end
      end
      describe "result" do
        let(:result) { service.create_category! }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns created category" do
          expect(result.data).to eq BxResourceCategory.last
        end
        it "created category has 'test' as name" do
          expect(result.data.name).to eq "test"
        end
        it "created category has 'test_desc' as description" do
          expect(result.data.description).to eq "test_desc"
        end
        it "created category has 1 as project_id " do
          expect(result.data.project_id).to eq 1
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.create_category!
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'create' as operation_type" do
          service.create_category!
          expect(BxHistory.last.operation_type).to eq "create"
        end
        it "created history has 'create_category' as operation" do
          service.create_category!
          expect(BxHistory.last.operation).to eq "create_category"
        end
        it "created history has name of created category as key" do
          service.create_category!
          expect(BxHistory.last.key).to eq "test"
        end
        it "created history has id of created category as source_id" do
          result = service.create_category!
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        describe "detail of created history that property is 'name'" do
          it "exists" do
            service.create_category!
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq true
          end
          it "change to 'test' form empty" do
            service.create_category!
            detail = BxHistory.last.details.find { |detail| detail.property == "name" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test"
          end
        end
        describe "detail of created history that property is 'description'" do
          it "exists" do
            service.create_category!
            expect(BxHistory.last.details.any? { |detail| detail.property == "description" }).to eq true
          end
          it "change to 'test_desc' form empty" do
            service.create_category!
            detail = BxHistory.last.details.find { |detail| detail.property == "description" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test_desc"
          end
        end
      end
    end# }}}

    context "when input without description" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 1 category" do
          expect { service.create_category! }.to change { BxResourceCategory.count }.by(1)
        end
        it "create 1 history" do
          expect { service.create_category! }.to change { BxHistory.count }.by(1)
        end
        it "create 1 history detail" do
          expect { service.create_category! }.to change { BxHistoryDetail.count }.by(1)
        end
      end
      describe "result" do
        let(:result) { service.create_category! }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns created category" do
          expect(result.data).to eq BxResourceCategory.last
        end
        it "created category has 'test' as name" do
          expect(result.data.name).to eq "test"
        end
        it "created category has nil as description" do
          expect(result.data.description).to be_empty
        end
        it "created category has 1 as project_id " do
          expect(result.data.project_id).to eq 1
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.create_category!
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'create' as operation_type" do
          service.create_category!
          expect(BxHistory.last.operation_type).to eq "create"
        end
        it "created history has 'create_category' as operation" do
          service.create_category!
          expect(BxHistory.last.operation).to eq "create_category"
        end
        it "created history has name of created category as key" do
          service.create_category!
          expect(BxHistory.last.key).to eq "test"
        end
        it "created history has id of created category as source_id" do
          result = service.create_category!
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        describe "detail of created history that property is 'name'" do
          it "exists" do
            service.create_category!
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq true
          end
          it "change to 'test' form empty" do
            service.create_category!
            detail = BxHistory.last.details.find { |detail| detail.property == "name" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test"
          end
        end
        describe "detail of created history that property is 'description'" do
          it "not exists" do
            service.create_category!
            expect(BxHistory.last.details.any? { |detail| detail.property == "description" }).to eq false
          end
        end
      end
    end# }}}

    context "when input is invalid (without name)" do
      # TODO
    end

    context "when input with relational_issues" do
      # TODO
    end
  end
end
