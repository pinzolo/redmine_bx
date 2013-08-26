# coding: utf-8
class BxResourceHistoryService < BxHistoryService
  target :resource

  def register_create_root_history(root, issue_ids)
    self.register_history("create_root", root.id, root.changesets, issue_ids)
  end

  def register_add_branch_history(branch, issue_ids)
    self.register_history("create_branch", branch.root_node_id, branch.changesets, issue_ids)
  end

  def register_update_branch_history(branch, issue_ids)
    self.register_history("update_branch", branch.root_node_id, branch.changesets, issue_ids)
  end
end
