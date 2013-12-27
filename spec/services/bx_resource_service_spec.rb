# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxResourceService do
  fixtures :projects, :issues, :users, :bx_resource_nodes, :bx_resource_branches, :bx_resource_values, :bx_resource_categories
  let(:current_time) { Time.local(2013, 11, 16, 9, 0, 0) }
  let(:project) { Project.all.first }
  before(:each) do
    Time.stub(:now).and_return(current_time)
    User.stub(:current).and_return(User.find(1))
  end

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
        it "created history has 1 as changed_by" do
          result = service.create_category!
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.create_category!
          expect(BxHistory.last.changed_at).to eq current_time
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

    context "when input is invalid (without name)" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "", :description => "test_desc", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "not create category" do
          expect { service.create_category! }.not_to change { BxResourceCategory.count }
        end
        it "not create history" do
          expect { service.create_category! }.not_to change { BxHistory.count }
        end
        it "not create history detail" do
          expect { service.create_category! }.not_to change { BxHistoryDetail.count }
        end
      end
      describe "result" do
        let(:result) { service.create_category! }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is invalid_input" do
          expect(result.invalid_input?).to eq true
        end
      end
    end# }}}

    context "when input with relational_issues" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "test_desc", :project_id => project.id, :relational_issues => "1,#3 5") }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 3 relational issue records" do
          expect { service.create_category! }.to change { BxHistoryIssue.count }.by(3)
        end
        it "created relational issue has 1, 3, 5 as issue_id" do
          service.create_category!
          expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
        end
      end
    end# }}}
  end
end
