# coding: utf-8
class BxResourceService
  include BxService

  def create_category
    category = BxResourceCategory.create!(@input.params_for(:category, :lock_version))
    BxResourceHistoryService.new.register_create_category_history(category, @input.relational_issue_ids)
    category
  end

  def update_category(category)
    category.update_attributes!(@input.params_for(:category, :project_id))
    BxResourceHistoryService.new.register_update_category_history(category, @input.relational_issue_ids)
    category
  end

  def delete_category(category)
    category.branches.each do |branch|
      self.delete_branch(branch, false)
    end
    BxResourceNode.delete_all(:category_id => category.id)
    category.destroy
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

  def delete_branch(branch, history_registration = true)
    BxResourceValue.delete_all(:branch_id => branch.id)
    branch.destroy
    BxResourceHistoryService.new.register_delete_branch_history(branch) if history_registration
  end

  def create_resource
    resource = BxResourceNode.create!(@input.params_for(:resource, :lock_version))
    history_service = BxResourceHistoryService.new
    history = history_service.register_create_resource_history(resource, @input.relational_issue_ids)
    resource.branches.each do |branch|
      if @input.branch_values[branch.id].present?
        value = BxResourceValue.create!(:node_id => resource.id, :branch_id => branch.id, :value => @input.branch_values[branch.id])
        history_service.register_resource_value_history_details(value, history)
      end
    end
    resource
  end

  def update_resource(resource)
    resource.update_attributes!(@input.params_for(:resource, :project_id, :category_id, :parent_id))
    history_service = BxResourceHistoryService.new
    history = history_service.register_update_resource_history(resource, @input.relational_issue_ids)
    resource.branches.each do |branch|
      new_value = @input.branch_values[branch.id]

      value = resource.values.detect { |v| v.branch_id == branch.id }
      if value
        value.update_attributes!(:value => @input.branch_values[branch.id].to_s)
      else
        if new_value.present?
          value = BxResourceValue.create!(:node_id => resource.id, :branch_id => branch.id, :value => @input.branch_values[branch.id])
        end
      end
      history_service.register_resource_value_history_details(value, history) if value
    end
    resource.reload
  end

  def delete_resource(resource, history_registration = true)
    BxResourceValue.delete_all(:node_id => resource.id)
    resource.children.each do |child|
      self.delete_resource(child, false)
    end
    resource.destroy
    BxResourceHistoryService.new.register_delete_resource_history(resource) if history_registration
  end
end
