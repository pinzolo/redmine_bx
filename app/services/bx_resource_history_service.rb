# coding: utf-8
class BxResourceHistoryService < BxHistoryService
  target :resource

  def register_create_root_history(root, issue_ids)
    changesets = root.previous_changes.slice("code", "summary")
    self.register_history("create_root", root.code, root.id, changesets, issue_ids)
  end

  def register_add_branch_history(branch, issue_ids)
    changesets = branch.previous_changes.slice("code", "name")
    self.register_history("create_branch", branch.code, branch.root_node_id, changesets, issue_ids)
  end

  def register_update_branch_history(branch, issue_ids)
    changesets = branch.previous_changes.slice("code", "name")
    self.register_history("update_branch", branch.code, branch.root_node_id, changesets, issue_ids)
  end

  def register_delete_branch_history(branch)
    self.register_history("delete_branch", branch.code, branch.root_node_id, nil, nil)
  end
end
