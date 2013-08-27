# coding: utf-8
class BxResourceService
  include BxService

  def create_category
    category = BxResourceCategory.create!(@input.params_for(:category, :lock_version))
    BxResourceHistoryService.new.register_create_category_history(category, @input.relational_issue_ids)
    category
  end

  def add_branch
    branch = BxResourceBranch.create!(@input.params_for(:branch, :lock_version))
    BxResourceHistoryService.new.register_add_branch_history(branch, @input.relational_issue_ids)
    branch
  end

  def update_branch(branch)
    branch.update_attributes!(@input.params_for(:branch, :category_id))
    BxResourceHistoryService.new.register_update_branch_history(branch, @input.relational_issue_ids)
    branch
  end

  def delete_branch(branch)
    BxResourceValue.delete_all(:branch_id => branch.id)
    branch.destroy
    BxResourceHistoryService.new.register_delete_branch_history(branch)
  end
end
