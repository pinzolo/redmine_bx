# coding: utf-8
class BxTableDefHistoryService < BxHistoryService
  def register_create_table_group_history(table_group, issue_ids)
    changesets = table_group.previous_changes.slice("name", "database_id", "description")
    if changesets.key?("database_id")
      changesets["database"] = ["", table_group.database.name]
      changesets.delete("database_id")
    end
    data_types = table_group.data_types.map(&:name).join(", ")
    changesets["data_types"] = ["", data_types]
    self.register_history("table_group", "create_table_group", table_group.name, table_group.id, changesets, issue_ids)
  end
end
