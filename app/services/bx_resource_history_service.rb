# coding: utf-8
class BxResourceHistoryService < BxHistoryService
  target :resource

  def register_create_root_history(root, issue_ids)
    self.register_history("create_root", root.id, root.changesets, issue_ids)
  end
end
