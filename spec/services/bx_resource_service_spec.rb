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

  describe "#create_category!" do# {{{
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
  end# }}}

  describe "#update_category!" do# {{{
    context "when input is valid" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "test_desc", :project_id => project.id, :lock_version => 0) }
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
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "", :project_id => project.id, :lock_version => 0) }
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
      let(:form) { BxResourceCategoryForm.new(:name => "", :description => "test_desc", :project_id => project.id, :lock_version => 0) }
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

    context "when input is invalid lock_version" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "test_desc", :project_id => project.id, :lock_version => 1) }
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
        it "reason is conflict" do
          expect(result.conflict?).to eq true
        end
      end
    end# }}}

    context "when name not changed" do# {{{
      let(:form) { BxResourceCategoryForm.new(:name => "locales", :description => "test_desc", :project_id => project.id, :lock_version => 0) }
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
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "locale settings", :project_id => project.id, :lock_version => 0) }
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
      let(:form) { BxResourceCategoryForm.new(:name => "test", :description => "test_desc", :project_id => project.id, :lock_version => 0, :relational_issues => "1,#3 5") }
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
  end# }}}

  describe "#delete_category!" do# {{{
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
    it "delete branches that belong deleting category" do
      expect { service.delete_category!(category) }.to change { BxResourceBranch.count }.by(-2)
      expect(BxResourceBranch.where(:category_id => 1).count).to eq 0
    end
    it "delete resource values that belong deleting category" do
      expect { service.delete_category!(category) }.to change { BxResourceValue.count }.by(-14)
      expect(BxResourceValue.includes(:resource).all.any? { |value| value.resource.category_id == 1 }).to eq false
    end
  end# }}}

  describe "#add_branch!" do# {{{
    context "when input is valid" do# {{{
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => 1) }
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
      let(:form) { BxResourceBranchForm.new(:name => "", :code => "test_code", :category_id => 1) }
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
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => 1, :relational_issues => "1,#3 5") }
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
  end# }}}

  describe "#update_branch!" do# {{{
    context "when input is valid" do# {{{
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => 1, :lock_version => 0) }
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
      let(:form) { BxResourceBranchForm.new(:name => "", :code => "test_code", :category_id => 1, :lock_version => 0) }
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

    context "when input is invalid lock_version" do# {{{
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => 1, :lock_version => 1) }
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
        it "reason is conflict" do
          expect(result.conflict?).to eq true
        end
      end
    end# }}}

    context "when input with relational_issues" do# {{{
      let(:form) { BxResourceBranchForm.new(:name => "test_name", :code => "test_code", :category_id => 1, :lock_version => 0, :relational_issues => "1,#3 5") }
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
  end# }}}

  describe "#delete_branch!" do# {{{
    let(:service) { BxResourceService.new }
    let(:branch) { BxResourceBranch.find(1) }

    it "delete branch" do
      expect { service.delete_branch!(branch) }.to change { BxResourceBranch.count }.by(-1)
      expect(BxResourceBranch.where(:id => 1)).to be_empty
    end
    it "delete resource values that belong deleting branch" do
      expect { service.delete_branch!(branch) }.to change { BxResourceValue.count }.by(-7)
      expect(BxResourceValue.where(:branch_id => 1).count).to eq 0
    end
  end# }}}

  describe "#create_resource!" do# {{{
    context "on registration of root resource " do
      context "when input is valid (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1) }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 resource" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 2 history details" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(2)
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "test_code"
          end
          it "created resource has 'test_summary' as summary" do
            expect(result.data.summary).to eq "test_summary"
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 0 as parent_id " do
            expect(result.data.parent_id).to eq 0
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq true
            end
            it "change to 'test_summary' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "summary" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_summary"
            end
          end
        end
      end# }}}

      context "when input is valid (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 resource" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 4 history details" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(4)
          end
          it "create 2 resource values" do
            expect { service.create_resource! }.to change { BxResourceValue.count }.by(2)
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "test_code"
          end
          it "created resource has 'test_summary' as summary" do
            expect(result.data.summary).to eq "test_summary"
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 2 values" do
            expect(result.data.values.size).to eq 2
          end
          it "created resource value that branch_id is 1 has 'br1' as value" do
            expect(result.data.values.find { |value| value.branch_id == 1 }.value).to eq "br1"
          end
          it "created resource value that branch_id is 2 has 'br2' as value" do
            expect(result.data.values.find { |value| value.branch_id == 2 }.value).to eq "br2"
          end
          it "created resource has 0 as parent_id " do
            expect(result.data.parent_id).to eq 0
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq true
            end
            it "change to 'test_summary' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "summary" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_summary"
            end
          end
          describe "detail of created history that propert is 'value'" do
            it "exists 2 details" do
              service.create_resource!
              expect(BxHistory.last.details.where(:property => "value").count).to eq 2
            end
            it "change to 'br1' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br1" }
              expect(detail.old_value).to be_empty
            end
            it "change to 'br2' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br2" }
              expect(detail.old_value).to be_empty
            end
          end
        end
      end# }}}

      context "when input without summary (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "", :project_id => project.id, :category_id => 1) }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 resource" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 1 history detail" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(1)
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "test_code"
          end
          it "created resource has empty as summary" do
            expect(result.data.summary).to be_empty
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 0 as parent_id " do
            expect(result.data.parent_id).to eq 0
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "not exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq false
            end
          end
        end
      end# }}}

      context "when input without summary (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "", :project_id => project.id, :category_id => 1, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 category" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 3 history details" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(3)
          end
          it "create 2 resource values" do
            expect { service.create_resource! }.to change { BxResourceValue.count }.by(2)
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "test_code"
          end
          it "created resource has empty as summary" do
            expect(result.data.summary).to be_empty
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 2 values" do
            expect(result.data.values.size).to eq 2
          end
          it "created resource value that branch_id is 1 has 'br1' as value" do
            expect(result.data.values.find { |value| value.branch_id == 1 }.value).to eq "br1"
          end
          it "created resource value that branch_id is 2 has 'br2' as value" do
            expect(result.data.values.find { |value| value.branch_id == 2 }.value).to eq "br2"
          end
          it "created resource has 0 as parent_id " do
            expect(result.data.parent_id).to eq 0
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "not exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq false
            end
          end
          describe "detail of created history that propert is 'value'" do
            it "exists 2 details" do
              service.create_resource!
              expect(BxHistory.last.details.where(:property => "value").count).to eq 2
            end
            it "change to 'br1' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br1" }
              expect(detail.old_value).to be_empty
            end
            it "change to 'br2' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br2" }
              expect(detail.old_value).to be_empty
            end
          end
        end
      end# }}}

      context "when input without code (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "", :summary => "test_summary", :project_id => project.id, :category_id => 1) }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "not create resource" do
            expect { service.create_resource! }.not_to change { BxResourceNode.count }
          end
          it "not create history" do
            expect { service.create_resource! }.not_to change { BxHistory.count }
          end
          it "not create history detail" do
            expect { service.create_resource! }.not_to change { BxHistoryDetail.count }
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is failure" do
            expect(result.failure?).to eq true
          end
          it "reason is invalid_input" do
            expect(result.invalid_input?).to eq true
          end
        end
      end# }}}

      context "when input without code (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "", :summary => "test_summary", :project_id => project.id, :category_id => 1, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "not create resource" do
            expect { service.create_resource! }.not_to change { BxResourceNode.count }
          end
          it "not create history" do
            expect { service.create_resource! }.not_to change { BxHistory.count }
          end
          it "not create history detail" do
            expect { service.create_resource! }.not_to change { BxHistoryDetail.count }
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is failure" do
            expect(result.failure?).to eq true
          end
          it "reason is invalid_input" do
            expect(result.invalid_input?).to eq true
          end
        end
      end# }}}

      context "when input with relational_issues (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :relational_issues => "1,#3 5") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 3 relational issue records" do
            expect { service.create_resource! }.to change { BxHistoryIssue.count }.by(3)
          end
          it "created relational issue has 1, 3, 5 as issue_id" do
            service.create_resource!
            expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
          end
        end
      end# }}}

      context "when input with relational_issues (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :branch_value_1 => "br1" , :branch_value_2 => "br2", :relational_issues => "1,#3 5") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 3 relational issue records" do
            expect { service.create_resource! }.to change { BxHistoryIssue.count }.by(3)
          end
          it "created relational issue has 1, 3, 5 as issue_id" do
            service.create_resource!
            expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
          end
        end
      end# }}}
    end
    context "on registration of child resource " do
      context "when input is valid (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4) }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 resource" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 2 history details" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(2)
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "text:label:resources:test_code"
          end
          it "created resource has 'test_summary' as summary" do
            expect(result.data.summary).to eq "test_summary"
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 4 as parent_id " do
            expect(result.data.parent_id).to eq 4
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq true
            end
            it "change to 'test_summary' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "summary" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_summary"
            end
          end
        end
      end# }}}

      context "when input is valid (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 resource" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 4 history details" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(4)
          end
          it "create 2 resource values" do
            expect { service.create_resource! }.to change { BxResourceValue.count }.by(2)
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "text:label:resources:test_code"
          end
          it "created resource has 'test_summary' as summary" do
            expect(result.data.summary).to eq "test_summary"
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 2 values" do
            expect(result.data.values.size).to eq 2
          end
          it "created resource value that branch_id is 1 has 'br1' as value" do
            expect(result.data.values.find { |value| value.branch_id == 1 }.value).to eq "br1"
          end
          it "created resource value that branch_id is 2 has 'br2' as value" do
            expect(result.data.values.find { |value| value.branch_id == 2 }.value).to eq "br2"
          end
          it "created resource has 4 as parent_id " do
            expect(result.data.parent_id).to eq 4
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq true
            end
            it "change to 'test_summary' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "summary" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_summary"
            end
          end
          describe "detail of created history that propert is 'value'" do
            it "exists 2 details" do
              service.create_resource!
              expect(BxHistory.last.details.where(:property => "value").count).to eq 2
            end
            it "change to 'br1' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br1" }
              expect(detail.old_value).to be_empty
            end
            it "change to 'br2' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br2" }
              expect(detail.old_value).to be_empty
            end
          end
        end
      end# }}}

      context "when input without summary (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "", :project_id => project.id, :category_id => 1, :parent_id => 4) }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 resource" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 1 history detail" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(1)
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "text:label:resources:test_code"
          end
          it "created resource has empty as summary" do
            expect(result.data.summary).to be_empty
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 4 as parent_id " do
            expect(result.data.parent_id).to eq 4
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "not exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq false
            end
          end
        end
      end# }}}

      context "when input without summary (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 1 category" do
            expect { service.create_resource! }.to change { BxResourceNode.count }.by(1)
          end
          it "create 1 history" do
            expect { service.create_resource! }.to change { BxHistory.count }.by(1)
          end
          it "create 3 history details" do
            expect { service.create_resource! }.to change { BxHistoryDetail.count }.by(3)
          end
          it "create 2 resource values" do
            expect { service.create_resource! }.to change { BxResourceValue.count }.by(2)
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is success" do
            expect(result.success?).to eq true
          end
          it "returns created resource" do
            expect(result.data).to eq BxResourceNode.last
          end
          it "created resource has 'test_code' as code" do
            expect(result.data.code).to eq "test_code"
          end
          it "created resource has 'test_code' as path" do
            expect(result.data.path).to eq "text:label:resources:test_code"
          end
          it "created resource has empty as summary" do
            expect(result.data.summary).to be_empty
          end
          it "created resource has 1 as project_id " do
            expect(result.data.project_id).to eq 1
          end
          it "created resource has 1 as category_id " do
            expect(result.data.category_id).to eq 1
          end
          it "created resource has 2 values" do
            expect(result.data.values.size).to eq 2
          end
          it "created resource value that branch_id is 1 has 'br1' as value" do
            expect(result.data.values.find { |value| value.branch_id == 1 }.value).to eq "br1"
          end
          it "created resource value that branch_id is 2 has 'br2' as value" do
            expect(result.data.values.find { |value| value.branch_id == 2 }.value).to eq "br2"
          end
          it "created resource has 4 as parent_id " do
            expect(result.data.parent_id).to eq 4
          end
        end
        describe "history" do
          it "created history has 'resource' as target" do
            service.create_resource!
            expect(BxHistory.last.target).to eq "resource"
          end
          it "created history has 'create' as operation_type" do
            service.create_resource!
            expect(BxHistory.last.operation_type).to eq "create"
          end
          it "created history has 'create_resource' as operation" do
            service.create_resource!
            expect(BxHistory.last.operation).to eq "create_resource"
          end
          it "created history has code of created resource as key" do
            service.create_resource!
            expect(BxHistory.last.key).to eq "test_code"
          end
          it "created history has id of created resource as source_id" do
            result = service.create_resource!
            expect(BxHistory.last.source_id).to eq result.data.id
          end
          it "created history has 1 as changed_by" do
            result = service.create_resource!
            expect(BxHistory.last.changed_by).to eq 1
          end
          it "created history has current_time as changed_at" do
            result = service.create_resource!
            expect(BxHistory.last.changed_at).to eq current_time
          end
          describe "detail of created history that property is 'code'" do
            it "exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
            end
            it "change to 'test_code' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "code" }
              expect(detail.old_value).to be_empty
              expect(detail.new_value).to eq "test_code"
            end
          end
          describe "detail of created history that property is 'summary'" do
            it "not exists" do
              service.create_resource!
              expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq false
            end
          end
          describe "detail of created history that propert is 'value'" do
            it "exists 2 details" do
              service.create_resource!
              expect(BxHistory.last.details.where(:property => "value").count).to eq 2
            end
            it "change to 'br1' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br1" }
              expect(detail.old_value).to be_empty
            end
            it "change to 'br2' form empty" do
              service.create_resource!
              detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br2" }
              expect(detail.old_value).to be_empty
            end
          end
        end
      end# }}}

      context "when input without code (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4) }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "not create resource" do
            expect { service.create_resource! }.not_to change { BxResourceNode.count }
          end
          it "not create history" do
            expect { service.create_resource! }.not_to change { BxHistory.count }
          end
          it "not create history detail" do
            expect { service.create_resource! }.not_to change { BxHistoryDetail.count }
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is failure" do
            expect(result.failure?).to eq true
          end
          it "reason is invalid_input" do
            expect(result.invalid_input?).to eq true
          end
        end
      end# }}}

      context "when input without code (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "not create resource" do
            expect { service.create_resource! }.not_to change { BxResourceNode.count }
          end
          it "not create history" do
            expect { service.create_resource! }.not_to change { BxHistory.count }
          end
          it "not create history detail" do
            expect { service.create_resource! }.not_to change { BxHistoryDetail.count }
          end
          it "not create resource value" do
            expect { service.create_resource! }.not_to change { BxResourceValue.count }
          end
        end
        describe "result" do
          let(:result) { service.create_resource! }

          it "result is failure" do
            expect(result.failure?).to eq true
          end
          it "reason is invalid_input" do
            expect(result.invalid_input?).to eq true
          end
        end
      end# }}}

      context "when input with relational_issues (without value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :relational_issues => "1,#3 5") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 3 relational issue records" do
            expect { service.create_resource! }.to change { BxHistoryIssue.count }.by(3)
          end
          it "created relational issue has 1, 3, 5 as issue_id" do
            service.create_resource!
            expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
          end
        end
      end# }}}

      context "when input with relational_issues (with value)" do# {{{
        let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2", :relational_issues => "1,#3 5") }
        let(:service) { BxResourceService.new(form) }

        describe "data registration" do
          it "create 3 relational issue records" do
            expect { service.create_resource! }.to change { BxHistoryIssue.count }.by(3)
          end
          it "created relational issue has 1, 3, 5 as issue_id" do
            service.create_resource!
            expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
          end
        end
      end# }}}
    end
  end# }}}

  describe "#update_resource!" do
    context "when input is valid (without value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :category_id => 1, :project_id => project.id, :parent_id => 3, :lock_version => 0) }
      let(:service) { BxResourceService.new(form) }
      let(:resource) { BxResourceNode.find(4) }

      describe "data registration" do
        it "not create resource" do
          expect { service.update_resource!(resource) }.not_to change { BxResourceNode.count }
        end
        it "create 1 history" do
          expect { service.update_resource!(resource) }.to change { BxHistory.count }.by(1)
        end
        it "create 2 history details" do
          expect { service.update_resource!(resource) }.to change { BxHistoryDetail.count }.by(2)
        end
        it "not create resource value" do
          expect { service.update_resource!(resource) }.not_to change { BxResourceValue.count }
        end
      end
      describe "result" do
        let(:result) { service.update_resource!(resource) }

        it "result is success" do
          puts form.errors.inspect if result.invalid_input?
          expect(result.success?).to eq true
        end
        it "returns created resource" do
          expect(result.data).to eq BxResourceNode.last
        end
        it "created resource has 'test_code' as code" do
          expect(result.data.code).to eq "test_code"
        end
        it "created resource has 'test_code' as path" do
          expect(result.data.path).to eq "text:label:test_code"
        end
        it "created resource has 'test_summary' as summary" do
          expect(result.data.summary).to eq "test_summary"
        end
        it "created resource has 1 as project_id " do
          expect(result.data.project_id).to eq 1
        end
        it "created resource has 1 as category_id " do
          expect(result.data.category_id).to eq 1
        end
        it "created resource has 3 as parent_id " do
          expect(result.data.parent_id).to eq 3
        end
      end
      describe "history" do
        it "created history has 'resource' as target" do
          service.update_resource!(resource)
          expect(BxHistory.last.target).to eq "resource"
        end
        it "created history has 'update' as operation_type" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation_type).to eq "update"
        end
        it "created history has 'update_resource' as operation" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation).to eq "update_resource"
        end
        it "created history has code of created resource as key" do
          service.update_resource!(resource)
          expect(BxHistory.last.key).to eq "test_code"
        end
        it "created history has id of created resource as source_id" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        it "created history has 1 as changed_by" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "detail of created history that property is 'code'" do
          it "exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
          end
          it "change to 'test_code' form 'resources'" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "code" }
            expect(detail.old_value).to eq "resources"
            expect(detail.new_value).to eq "test_code"
          end
        end
        describe "detail of created history that property is 'summary'" do
          it "exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq true
          end
          it "change to 'test_summary' form 'Resources'" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "summary" }
            expect(detail.old_value).to eq "Resources"
            expect(detail.new_value).to eq "test_summary"
          end
        end
      end
    end# }}}
=begin
    context "when input is valid (with value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 1 resource" do
          expect { service.update_resource!(resource) }.to change { BxResourceNode.count }.by(1)
        end
        it "create 1 history" do
          expect { service.update_resource!(resource) }.to change { BxHistory.count }.by(1)
        end
        it "create 4 history details" do
          expect { service.update_resource!(resource) }.to change { BxHistoryDetail.count }.by(4)
        end
        it "create 2 resource values" do
          expect { service.update_resource!(resource) }.to change { BxResourceValue.count }.by(2)
        end
      end
      describe "result" do
        let(:result) { service.update_resource!(resource) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns created resource" do
          expect(result.data).to eq BxResourceNode.last
        end
        it "created resource has 'test_code' as code" do
          expect(result.data.code).to eq "test_code"
        end
        it "created resource has 'test_code' as path" do
          expect(result.data.path).to eq "text:label:resources:test_code"
        end
        it "created resource has 'test_summary' as summary" do
          expect(result.data.summary).to eq "test_summary"
        end
        it "created resource has 1 as project_id " do
          expect(result.data.project_id).to eq 1
        end
        it "created resource has 1 as category_id " do
          expect(result.data.category_id).to eq 1
        end
        it "created resource has 2 values" do
          expect(result.data.values.size).to eq 2
        end
        it "created resource value that branch_id is 1 has 'br1' as value" do
          expect(result.data.values.find { |value| value.branch_id == 1 }.value).to eq "br1"
        end
        it "created resource value that branch_id is 2 has 'br2' as value" do
          expect(result.data.values.find { |value| value.branch_id == 2 }.value).to eq "br2"
        end
        it "created resource has 4 as parent_id " do
          expect(result.data.parent_id).to eq 4
        end
      end
      describe "history" do
        it "created history has 'resource' as target" do
          service.update_resource!(resource)
          expect(BxHistory.last.target).to eq "resource"
        end
        it "created history has 'create' as operation_type" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation_type).to eq "create"
        end
        it "created history has 'create_resource' as operation" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation).to eq "create_resource"
        end
        it "created history has code of created resource as key" do
          service.update_resource!(resource)
          expect(BxHistory.last.key).to eq "test_code"
        end
        it "created history has id of created resource as source_id" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        it "created history has 1 as changed_by" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "detail of created history that property is 'code'" do
          it "exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
          end
          it "change to 'test_code' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "code" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test_code"
          end
        end
        describe "detail of created history that property is 'summary'" do
          it "exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq true
          end
          it "change to 'test_summary' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "summary" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test_summary"
          end
        end
        describe "detail of created history that propert is 'value'" do
          it "exists 2 details" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.where(:property => "value").count).to eq 2
          end
          it "change to 'br1' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br1" }
            expect(detail.old_value).to be_empty
          end
          it "change to 'br2' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br2" }
            expect(detail.old_value).to be_empty
          end
        end
      end
    end# }}}

    context "when input without summary (without value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "test_code", :summary => "", :project_id => project.id, :category_id => 1, :parent_id => 4) }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 1 resource" do
          expect { service.update_resource!(resource) }.to change { BxResourceNode.count }.by(1)
        end
        it "create 1 history" do
          expect { service.update_resource!(resource) }.to change { BxHistory.count }.by(1)
        end
        it "create 1 history detail" do
          expect { service.update_resource!(resource) }.to change { BxHistoryDetail.count }.by(1)
        end
        it "not create resource value" do
          expect { service.update_resource!(resource) }.not_to change { BxResourceValue.count }
        end
      end
      describe "result" do
        let(:result) { service.update_resource!(resource) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns created resource" do
          expect(result.data).to eq BxResourceNode.last
        end
        it "created resource has 'test_code' as code" do
          expect(result.data.code).to eq "test_code"
        end
        it "created resource has 'test_code' as path" do
          expect(result.data.path).to eq "text:label:resources:test_code"
        end
        it "created resource has empty as summary" do
          expect(result.data.summary).to be_empty
        end
        it "created resource has 1 as project_id " do
          expect(result.data.project_id).to eq 1
        end
        it "created resource has 1 as category_id " do
          expect(result.data.category_id).to eq 1
        end
        it "created resource has 4 as parent_id " do
          expect(result.data.parent_id).to eq 4
        end
      end
      describe "history" do
        it "created history has 'resource' as target" do
          service.update_resource!(resource)
          expect(BxHistory.last.target).to eq "resource"
        end
        it "created history has 'create' as operation_type" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation_type).to eq "create"
        end
        it "created history has 'create_resource' as operation" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation).to eq "create_resource"
        end
        it "created history has code of created resource as key" do
          service.update_resource!(resource)
          expect(BxHistory.last.key).to eq "test_code"
        end
        it "created history has id of created resource as source_id" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        it "created history has 1 as changed_by" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "detail of created history that property is 'code'" do
          it "exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
          end
          it "change to 'test_code' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "code" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test_code"
          end
        end
        describe "detail of created history that property is 'summary'" do
          it "not exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq false
          end
        end
      end
    end# }}}

    context "when input without summary (with value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "test_code", :summary => "", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 1 category" do
          expect { service.update_resource!(resource) }.to change { BxResourceNode.count }.by(1)
        end
        it "create 1 history" do
          expect { service.update_resource!(resource) }.to change { BxHistory.count }.by(1)
        end
        it "create 3 history details" do
          expect { service.update_resource!(resource) }.to change { BxHistoryDetail.count }.by(3)
        end
        it "create 2 resource values" do
          expect { service.update_resource!(resource) }.to change { BxResourceValue.count }.by(2)
        end
      end
      describe "result" do
        let(:result) { service.update_resource!(resource) }

        it "result is success" do
          expect(result.success?).to eq true
        end
        it "returns created resource" do
          expect(result.data).to eq BxResourceNode.last
        end
        it "created resource has 'test_code' as code" do
          expect(result.data.code).to eq "test_code"
        end
        it "created resource has 'test_code' as path" do
          expect(result.data.path).to eq "text:label:resources:test_code"
        end
        it "created resource has empty as summary" do
          expect(result.data.summary).to be_empty
        end
        it "created resource has 1 as project_id " do
          expect(result.data.project_id).to eq 1
        end
        it "created resource has 1 as category_id " do
          expect(result.data.category_id).to eq 1
        end
        it "created resource has 2 values" do
          expect(result.data.values.size).to eq 2
        end
        it "created resource value that branch_id is 1 has 'br1' as value" do
          expect(result.data.values.find { |value| value.branch_id == 1 }.value).to eq "br1"
        end
        it "created resource value that branch_id is 2 has 'br2' as value" do
          expect(result.data.values.find { |value| value.branch_id == 2 }.value).to eq "br2"
        end
        it "created resource has 4 as parent_id " do
          expect(result.data.parent_id).to eq 4
        end
      end
      describe "history" do
        it "created history has 'resource' as target" do
          service.update_resource!(resource)
          expect(BxHistory.last.target).to eq "resource"
        end
        it "created history has 'create' as operation_type" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation_type).to eq "create"
        end
        it "created history has 'create_resource' as operation" do
          service.update_resource!(resource)
          expect(BxHistory.last.operation).to eq "create_resource"
        end
        it "created history has code of created resource as key" do
          service.update_resource!(resource)
          expect(BxHistory.last.key).to eq "test_code"
        end
        it "created history has id of created resource as source_id" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.source_id).to eq result.data.id
        end
        it "created history has 1 as changed_by" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_by).to eq 1
        end
        it "created history has current_time as changed_at" do
          result = service.update_resource!(resource)
          expect(BxHistory.last.changed_at).to eq current_time
        end
        describe "detail of created history that property is 'code'" do
          it "exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "code" }).to eq true
          end
          it "change to 'test_code' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "code" }
            expect(detail.old_value).to be_empty
            expect(detail.new_value).to eq "test_code"
          end
        end
        describe "detail of created history that property is 'summary'" do
          it "not exists" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.any? { |detail| detail.property == "summary" }).to eq false
          end
        end
        describe "detail of created history that propert is 'value'" do
          it "exists 2 details" do
            service.update_resource!(resource)
            expect(BxHistory.last.details.where(:property => "value").count).to eq 2
          end
          it "change to 'br1' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br1" }
            expect(detail.old_value).to be_empty
          end
          it "change to 'br2' form empty" do
            service.update_resource!(resource)
            detail = BxHistory.last.details.find { |detail| detail.property == "value" && detail.new_value == "br2" }
            expect(detail.old_value).to be_empty
          end
        end
      end
    end# }}}

    context "when input without code (without value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4) }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "not create resource" do
          expect { service.update_resource!(resource) }.not_to change { BxResourceNode.count }
        end
        it "not create history" do
          expect { service.update_resource!(resource) }.not_to change { BxHistory.count }
        end
        it "not create history detail" do
          expect { service.update_resource!(resource) }.not_to change { BxHistoryDetail.count }
        end
        it "not create resource value" do
          expect { service.update_resource!(resource) }.not_to change { BxResourceValue.count }
        end
      end
      describe "result" do
        let(:result) { service.update_resource!(resource) }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is invalid_input" do
          expect(result.invalid_input?).to eq true
        end
      end
    end# }}}

    context "when input without code (with value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2") }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "not create resource" do
          expect { service.update_resource!(resource) }.not_to change { BxResourceNode.count }
        end
        it "not create history" do
          expect { service.update_resource!(resource) }.not_to change { BxHistory.count }
        end
        it "not create history detail" do
          expect { service.update_resource!(resource) }.not_to change { BxHistoryDetail.count }
        end
        it "not create resource value" do
          expect { service.update_resource!(resource) }.not_to change { BxResourceValue.count }
        end
      end
      describe "result" do
        let(:result) { service.update_resource!(resource) }

        it "result is failure" do
          expect(result.failure?).to eq true
        end
        it "reason is invalid_input" do
          expect(result.invalid_input?).to eq true
        end
      end
    end# }}}

    context "when input with relational_issues (without value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :relational_issues => "1,#3 5") }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 3 relational issue records" do
          expect { service.update_resource!(resource) }.to change { BxHistoryIssue.count }.by(3)
        end
        it "created relational issue has 1, 3, 5 as issue_id" do
          service.update_resource!(resource)
          expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
        end
      end
    end# }}}

    context "when input with relational_issues (with value)" do# {{{
      let(:form) { BxResourceForm.new(:code => "test_code", :summary => "test_summary", :project_id => project.id, :category_id => 1, :parent_id => 4, :branch_value_1 => "br1" , :branch_value_2 => "br2", :relational_issues => "1,#3 5") }
      let(:service) { BxResourceService.new(form) }

      describe "data registration" do
        it "create 3 relational issue records" do
          expect { service.update_resource!(resource) }.to change { BxHistoryIssue.count }.by(3)
        end
        it "created relational issue has 1, 3, 5 as issue_id" do
          service.update_resource!(resource)
          expect(BxHistory.last.issues.map(&:id)).to match_array [1, 3, 5]
        end
      end
    end# }}}
=end
  end
end
