# coding: utf-8
class BxResourceHistoryService < BxHistoryService
  def register_create_category_history(category, issue_ids)
    changesets = category.previous_changes.slice("name", "description")
    self.register_history("resource_category", "create_category", category.name, category.id, changesets, issue_ids)
  end

  def register_update_category_history(category, issue_ids)
    changesets = category.previous_changes.slice("name", "description")
    self.register_history("resource_category", "update_category", category.name, category.id, changesets, issue_ids)
  end

  def register_add_branch_history(branch, issue_ids)
    changesets = branch.previous_changes.slice("code", "name")
    self.register_history("resource_category", "create_branch", branch.code, branch.category_id, changesets, issue_ids)
  end

  def register_update_branch_history(branch, issue_ids)
    changesets = branch.previous_changes.slice("code", "name")
    self.register_history("resource_category", "update_branch", branch.code, branch.category_id, changesets, issue_ids)
  end

  def register_delete_branch_history(branch)
    self.register_history("resource_category", "delete_branch", branch.code, branch.category_id, nil, nil)
  end

  def register_create_resource_history(resource, issue_ids)
    changesets = resource.previous_changes.slice("code", "summary")
    self.register_history("resource", "create_resource", resource.code, resource.id, changesets, issue_ids)
  end

  def register_update_resource_history(resource, issue_ids)
    changesets = resource.previous_changes.slice("code", "summary")
    self.register_history("resource", "update_resource", resource.code, resource.id, changesets, issue_ids)
  end

  def register_resource_value_history_details(value, history)
    changesets = value.previous_changes.slice("value")
    self.register_history_details(history, changesets)
  end
end
