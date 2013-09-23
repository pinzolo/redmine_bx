# coding: utf-8
class BxTableDefHistoryService < BxHistoryService
  def register_create_table_group_history(table_group, issue_ids)
    data_types = table_group.data_types.map(&:name).join(",")
    changesets = table_group.previous_changes.slice("name", "description").merge("data_types" => ["", data_types])
    self.register_history("table_group", "create_table_group", table_group.name, table_group.id, changesets, issue_ids)
  end
end
