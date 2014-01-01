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
        it "created category has empty as description" do
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

  describe "#update_category!" do
    context "when input is valid" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "test_desc", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }
      let(:category) { BxResourceCategory.find(1) }

      describe "data registration" do
        it "not create history" do
          expect { service.update_category!(category) }.not_to change { BxResourceCategory.count }
        end
        it "create 1 history" do
          expect { service.update_category!(category) }.to change { BxHistory.count }.by(1)
        end
        it "create 2 history details" do
          expect { service.update_category!(category) }.to change { BxHistoryDetail.count }.by(2)
        end
      end
      describe "result" do
        let(:result) { service.update_category!(category) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns updated category" do
          expect(result.data).to eq BxResourceCategory.find(1)
        end
        it "updated category has 'test' as name" do
          expect(result.data.name).to eq "test"
        end
        it "updated category has 'test_desc' as description" do
          expect(result.data.description).to eq "test_desc"
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.update_category!(category)
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'update' as operation_type" do
          service.update_category!(category)
          expect(BxHistory.last.operation_type).to eq "update"
        end
        it "created history has 'update_category' as operation" do
          service.update_category!(category)
          expect(BxHistory.last.operation).to eq "update_category"
        end
        it "created history has name of updated category as key" do
          service.update_category!(category)
          expect(BxHistory.last.key).to eq "test"
        end
        it "created history has id of updated category as source_id" do
          result = service.update_category!(category)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        it "created history has 1 as changed_by" do
          result = service.update_category!(category)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_category!(category)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "details of created history that property is 'name'" do
          it "exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq true
          end
          it "change to 'test' form 'locales'" do
            service.update_category!(category)
            detail = BxHistory.last.details.find { |detail| detail.property == "name" }
            expect(detail.old_value).to eq "locales"
            expect(detail.new_value).to eq "test"
          end
        end
        describe "details of created history that property is 'description'" do
          it "exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "description" }).to eq true
          end
          it "change to 'test_desc' form 'locale settings'" do
            service.update_category!(category)
            detail = BxHistory.last.details.find { |detail| detail.property == "description" }
            expect(detail.old_value).to eq "locale settings"
            expect(detail.new_value).to eq "test_desc"
          end
        end
      end
    end# }}}

    context "when input without description" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }
      let(:category) { BxResourceCategory.find(1) }

      describe "data registration" do
        it "not create history" do
          expect { service.update_category!(category) }.not_to change { BxResourceCategory.count }
        end
        it "create 1 history" do
          expect { service.update_category!(category) }.to change { BxHistory.count }.by(1)
        end
        it "create 2 history details" do
          expect { service.update_category!(category) }.to change { BxHistoryDetail.count }.by(2)
        end
      end
      describe "result" do
        let(:result) { service.update_category!(category) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns updated category" do
          expect(result.data).to eq BxResourceCategory.find(1)
        end
        it "updated category has 'test' as name" do
          expect(result.data.name).to eq "test"
        end
        it "updated category has empty as description" do
          expect(result.data.description).to be_empty
        end
        it "project_id of updated category is not changed" do
          expect(result.data.project_id).to eq category.project_id
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.update_category!(category)
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'update' as operation_type" do
          service.update_category!(category)
          expect(BxHistory.last.operation_type).to eq "update"
        end
        it "created history has 'update_category' as operation" do
          service.update_category!(category)
          expect(BxHistory.last.operation).to eq "update_category"
        end
        it "created history has name of updated category as key" do
          service.update_category!(category)
          expect(BxHistory.last.key).to eq "test"
        end
        it "created history has id of updated category as source_id" do
          result = service.update_category!(category)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        describe "details of updated history that property is 'name'" do
          it "exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq true
          end
          it "change to 'test' form 'locales'" do
            service.update_category!(category)
            detail = BxHistory.last.details.find { |detail| detail.property == "name" }
            expect(detail.old_value).to eq "locales"
            expect(detail.new_value).to eq "test"
          end
        end
        describe "details of updated history that property is 'description'" do
          it "exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "description" }).to eq true
          end
          it "change to empty form 'locale settings'" do
            service.update_category!(category)
            detail = BxHistory.last.details.find { |detail| detail.property == "description" }
            expect(detail.old_value).to eq "locale settings"
            expect(detail.new_value).to be_empty
          end
        end
      end
    end# }}}

    context "when input is invalid (without name)" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "", :description => "test_desc", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }
      let(:category) { BxResourceCategory.find(1) }

      describe "data registration" do
        it "not update category" do
          before_version = category.lock_version
          service.update_category!(category)
          expect(BxResourceCategory.find(1).lock_version).to eq before_version
        end
        it "not create history" do
          expect { service.update_category!(category) }.not_to change { BxHistory.count }
        end
        it "not create history detail" do
          expect { service.update_category!(category) }.not_to change { BxHistoryDetail.count }
        end
      end
      describe "result" do
        let(:result) { service.update_category!(category) }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is invalid_input" do
          expect(result.invalid_input?).to eq true
        end
      end
    end# }}}

    context "when name not changed" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "locales", :description => "test_desc", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }
      let(:category) { BxResourceCategory.find(1) }

      describe "data registration" do
        it "not create history" do
          expect { service.update_category!(category) }.not_to change { BxResourceCategory.count }
        end
        it "create 1 history" do
          expect { service.update_category!(category) }.to change { BxHistory.count }.by(1)
        end
        it "create 1 history detail" do
          expect { service.update_category!(category) }.to change { BxHistoryDetail.count }.by(1)
        end
      end
      describe "result" do
        let(:result) { service.update_category!(category) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns updated category" do
          expect(result.data).to eq BxResourceCategory.find(1)
        end
        it "updated category has 'locales' as name" do
          expect(result.data.name).to eq "locales"
        end
        it "updated category has 'test_desc' as description" do
          expect(result.data.description).to eq "test_desc"
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.update_category!(category)
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'update' as operation_type" do
          service.update_category!(category)
          expect(BxHistory.last.operation_type).to eq "update"
        end
        it "created history has 'update_category' as operation" do
          service.update_category!(category)
          expect(BxHistory.last.operation).to eq "update_category"
        end
        it "created history has name of updated category as key" do
          service.update_category!(category)
          expect(BxHistory.last.key).to eq "locales"
        end
        it "created history has id of updated category as source_id" do
          result = service.update_category!(category)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        it "created history has 1 as changed_by" do
          result = service.update_category!(category)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_category!(category)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "details of updated history that property is 'name'" do
          it "not exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq false
          end
        end
        describe "details of updated history that property is 'description'" do
          it "exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "description" }).to eq true
          end
          it "change to 'test_desc' form 'locale settings'" do
            service.update_category!(category)
            detail = BxHistory.last.details.find { |detail| detail.property == "description" }
            expect(detail.old_value).to eq "locale settings"
            expect(detail.new_value).to eq "test_desc"
          end
        end
      end
    end# }}}

    context "when description not changed" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "locale settings", :project_id => project.id) }
      let(:service) { BxResourceService.new(form) }
      let(:category) { BxResourceCategory.find(1) }

      describe "data registration" do
        it "not create history" do
          expect { service.update_category!(category) }.not_to change { BxResourceCategory.count }
        end
        it "create 1 history" do
          expect { service.update_category!(category) }.to change { BxHistory.count }.by(1)
        end
        it "create 1 history detail" do
          expect { service.update_category!(category) }.to change { BxHistoryDetail.count }.by(1)
        end
      end
      describe "result" do
        let(:result) { service.update_category!(category) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns updated category" do
          expect(result.data).to eq BxResourceCategory.find(1)
        end
        it "updated category has 'test' as name" do
          expect(result.data.name).to eq "test"
        end
        it "updated category has 'locale settings' as description" do
          expect(result.data.description).to eq "locale settings"
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.update_category!(category)
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'update' as operation_type" do
          service.update_category!(category)
          expect(BxHistory.last.operation_type).to eq "update"
        end
        it "created history has 'update_category' as operation" do
          service.update_category!(category)
          expect(BxHistory.last.operation).to eq "update_category"
        end
        it "created history has name of updated category as key" do
          service.update_category!(category)
          expect(BxHistory.last.key).to eq "test"
        end
        it "created history has id of updated category as source_id" do
          result = service.update_category!(category)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        it "created history has 1 as changed_by" do
          result = service.update_category!(category)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_category!(category)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "details of updated history that property is 'name'" do
          it "exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq true
          end
          it "change to 'test' form 'locales'" do
            service.update_category!(category)
            detail = BxHistory.last.details.find { |detail| detail.property == "name" }
            expect(detail.old_value).to eq "locales"
            expect(detail.new_value).to eq "test"
          end
        end
        describe "details of updated history that property is 'description'" do
          it "not exists" do
            service.update_category!(category)
            expect(BxHistory.last.details.any? { |detail| detail.property == "description" }).to eq false
          end
        end
      end
    end# }}}

    context "when input with relational_issues" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "test_desc", :project_id => project.id, :relational_issues => "1,#3 5") }
      let(:service) { BxResourceService.new(form) }
      let(:category) { BxResourceCategory.find(1) }

      describe "data registration" do
        it "create 3 relational issue records" do
          expect { service.update_category!(category) }.to change { BxHistoryIssue.count }.by(3)
        end
        it "updated relational issue has 1, 3, 5 as issue_id" do
          service.update_category!(category)
          expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
        end
      end
    end# }}}
  end

  describe "#delete_category!" do
    let(:service) { BxResourceService.new }
    let(:category) { BxResourceCategory.find(1) }

    it "delete category" do
      expect { service.delete_category!(category) }.to change { BxResourceCategory.count }.by(-1)
      expect(BxResourceCategory.where(:id => 1)).to be_empty
    end
    it "delete resources that belong deleting category" do
      expect { service.delete_category!(category) }.to change { BxResourceNode.count }.by(-13)
      expect(BxResourceNode.where(:category_id => 1).count).to eq 0
    end
  end

  describe "#add_branch!" do
    context "when input is valid" do# {{{
      let(:category) { BxResourceCategory.find(1) }
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => category.id) }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 1 branch" do
          expect { service.add_branch! }.to change { BxResourceBranch.count }.by(1)
        end
        it "create 1 history" do
          expect { service.add_branch! }.to change { BxHistory.count }.by(1)
        end
        it "create 2 history details" do
          expect { service.add_branch! }.to change { BxHistoryDetail.count }.by(2)
        end
      end
      describe "result" do
        let(:result) { service.add_branch! }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns created branch" do
          expect(result.data).to eq BxResourceBranch.last
        end
        it "created branch has 'test_name' as name" do
          expect(result.data.name).to eq "test_name"
        end
        it "created branch has 'test_code' as code" do
          expect(result.data.code).to eq "test_code"
        end
        it "created branch has 1 as category_id " do
          expect(result.data.category_id).to eq 1
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.add_branch!
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'create' as operation_type" do
          service.add_branch!
          expect(BxHistory.last.operation_type).to eq "create"
        end
        it "created history has 'create_branch' as operation" do
          service.add_branch!
          expect(BxHistory.last.operation).to eq "create_branch"
        end
        it "created history has code of created branch as key" do
          service.add_branch!
          expect(BxHistory.last.key).to eq "test_code"
        end
        it "created history has category_id of created branch as source_id" do
          result = service.add_branch!
          expect(BxHistory.last.source_id).to eq result.data.category_id
        end
        it "created history has 1 as changed_by" do
          result = service.add_branch!
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.add_branch!
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "details of created history that property is 'name'" do
          it "exists" do
            service.add_branch!
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq true
          end
          it "change to 'test_name' form empty" do
            service.add_branch!
            detail = BxHistory.last.details.find { |detail| detail.property == "name" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test_name"
          end
        end
        describe "details of created history that property is 'code'" do
          it "exists" do
            service.add_branch!
            expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
          end
          it "change to 'test_code' form empty" do
            service.add_branch!
            detail = BxHistory.last.details.find { |detail| detail.property == "code" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test_code"
          end
        end
      end
    end# }}}

    context "when input is invalid (without name)" do# {{{
      let(:category) { BxResourceCategory.find(1) }
      let(:form) { BxResourceBranchForm.new(:name => "", :code => "test_code", :category_id => category.id) }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "not create branch" do
          expect { service.add_branch! }.not_to change { BxResourceBranch.count }
        end
        it "not create history" do
          expect { service.add_branch! }.not_to change { BxHistory.count }
        end
        it "not create history detail" do
          expect { service.add_branch! }.not_to change { BxHistoryDetail.count }
        end
      end
      describe "result" do
        let(:result) { service.add_branch! }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is invalid_input" do
          expect(result.invalid_input?).to eq true
        end
      end
    end# }}}

    context "when input with relational_issues" do# {{{
      let(:category) { BxResourceCategory.find(1) }
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => category.id, :relational_issues => "1,#3 5") }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 3 relational issue records" do
          expect { service.add_branch! }.to change { BxHistoryIssue.count }.by(3)
        end
        it "created relational issue has 1, 3, 5 as issue_id" do
          service.add_branch!
          expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
        end
      end
    end# }}}
  end

  describe "#update_branch!" do
    context "when input is valid" do# {{{
      let(:category) { BxResourceCategory.find(1) }
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => category.id) }
      let(:service) { BxResourceService.new(form) }
      let(:branch) { BxResourceBranch.find(1) }

      describe "data registration" do
        it "not branch registration" do
          expect { service.update_branch!(branch) }.not_to change { BxResourceBranch.count }
        end
        it "create 1 history" do
          expect { service.update_branch!(branch) }.to change { BxHistory.count }.by(1)
        end
        it "create 2 history details" do
          expect { service.update_branch!(branch) }.to change { BxHistoryDetail.count }.by(2)
        end
      end
      describe "result" do
        let(:result) { service.update_branch!(branch) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns updated branch" do
          expect(result.data).to eq BxResourceBranch.find(branch.id)
        end
        it "updated branch has 'test_name' as name" do
          expect(result.data.name).to eq "test_name"
        end
        it "updated branch has 'test_code' as code" do
          expect(result.data.code).to eq "test_code"
        end
        it "updated branch has 1 as category_id " do
          expect(result.data.category_id).to eq 1
        end
      end
      describe "history" do
        it "created history has 'resource_category' as target" do
          service.update_branch!(branch)
          expect(BxHistory.last.target).to eq "resource_category"
        end
        it "created history has 'update' as operation_type" do
          service.update_branch!(branch)
          expect(BxHistory.last.operation_type).to eq "update"
        end
        it "created history has 'update_branch' as operation" do
          service.update_branch!(branch)
          expect(BxHistory.last.operation).to eq "update_branch"
        end
        it "created history has code of created branch as key" do
          service.update_branch!(branch)
          expect(BxHistory.last.key).to eq "test_code"
        end
        it "created history has category_id of created branch as source_id" do
          result = service.update_branch!(branch)
          expect(BxHistory.last.source_id).to eq result.data.category_id
        end
        it "created history has 1 as changed_by" do
          result = service.update_branch!(branch)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_branch!(branch)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "details of created history that property is 'name'" do
          it "exists" do
            service.update_branch!(branch)
            expect(BxHistory.last.details.any? { |detail| detail.property == "name" }).to eq true
          end
          it "change to 'test_name' form 'Japanese'" do
            service.update_branch!(branch)
            detail = BxHistory.last.details.find { |detail| detail.property == "name" }
            expect(detail.old_value).to eq "Japanese"
            expect(detail.new_value).to eq "test_name"
          end
        end
        describe "details of created history that property is 'code'" do
          it "exists" do
            service.update_branch!(branch)
            expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
          end
          it "change to 'test_code' form empty" do
            service.update_branch!(branch)
            detail = BxHistory.last.details.find { |detail| detail.property == "code" }
            expect(detail.old_value).to eq "ja"
            expect(detail.new_value).to eq "test_code"
          end
        end
      end
    end# }}}

    context "when input is invalid (without name)" do# {{{
      let(:category) { BxResourceCategory.find(1) }
      let(:form) { BxResourceBranchForm.new(:name => "", :code => "test_code", :category_id => category.id) }
      let(:service) { BxResourceService.new(form) }
      let(:branch) { BxResourceBranch.find(1) }

      describe "data registration" do
        it "not update branch" do
          before_version = branch.lock_version
          service.update_branch!(branch)
          expect(BxResourceBranch.find(1).lock_version).to eq before_version
        end
        it "not create history" do
          expect { service.update_branch!(branch) }.not_to change { BxHistory.count }
        end
        it "not create history detail" do
          expect { service.update_branch!(branch) }.not_to change { BxHistoryDetail.count }
        end
      end
      describe "result" do
        let(:result) { service.update_branch!(branch) }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is invalid_input" do
          expect(result.invalid_input?).to eq true
        end
      end
    end# }}}

    context "when input with relational_issues" do# {{{
      let(:category) { BxResourceCategory.find(1) }
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => category.id, :relational_issues => "1,#3 5") }
      let(:service) { BxResourceService.new(form) }
      let(:branch) { BxResourceBranch.find(1) }

      describe "data registration" do
        it "create 3 relational issue records" do
          expect { service.update_branch!(branch) }.to change { BxHistoryIssue.count }.by(3)
        end
        it "created relational issue has 1, 3, 5 as issue_id" do
          service.update_branch!(branch)
          expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
        end
      end
    end# }}}
  end
end
