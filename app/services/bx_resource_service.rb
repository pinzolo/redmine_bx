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

  def create_resource
    codes = @input.code.split(":")
    parent_id = @input.parent_id
    resource = nil
    history_service = BxResourceHistoryService.new
    codes.each do |code|
      summary = codes.last == code ? @input.summary : ""
      resource = BxResourceNode.create!(:project_id => @input.project_id,
                                        :parent_id => parent_id,
                                        :category_id => @input.category_id,
                                        :code => code,
                                        :summary => summary)
      parent_id = resource.id
      history_service.register_create_resource_history(resource, @input.relational_issue_ids)
    end
    create_resource_values(resource)
    BxResourceHistoryService.new.register_create_resource_history(resource, @input.relational_issue_ids)
    resource
  end

  private
  def create_resource_values(resource)
    resource.category.branches.each do |branch|
      if @input.branch_values[branch.id].present?
        BxResourceValue.create!(:node_id => resource.id, :branch_id => branch.id, :value => @input.branch_values[branch.id])
      end
    end
  end
end
