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

  def register_create_common_column_def_history(common_column_def, issue_ids)
    changesets = common_column_def.previous_changes.slice("physical_name", "logical_name", "data_type_id")
    if changesets.key?("data_type_id")
      changesets["data_type"] = ["", common_column_def.data_type.name]
      changesets.delete("data_type_id")
    end
    changesets = changesets.merge(common_column_def.previous_changes.slice("size", "scale", "nullable", "default_value", "primary_key_number", "position_type", "note"))
    self.register_history("table_group", "create_common_column_def", common_column_def.physical_name, common_column_def.table_group.id, changesets, issue_ids)
  end

  def register_update_common_column_def_history(common_column_def, issue_ids)
    changesets = common_column_def.previous_changes.slice("physical_name", "logical_name", "data_type_id")
    if changesets.key?("data_type_id")
      prev_data_type = BxDataType.find(changesets["data_type_id"].first)
      changesets["data_type"] = [prev_data_type.name, common_column_def.data_type.name]
      changesets.delete("data_type_id")
    end
    changesets = changesets.merge(common_column_def.previous_changes.slice("size", "scale", "nullable", "default_value", "primary_key_number", "position_type", "note"))
    self.register_history("table_group", "update_common_column_def", common_column_def.physical_name, common_column_def.table_group.id, changesets, issue_ids)
  end

  def register_delete_common_column_def_history(common_column_def)
    self.register_history("table_group", "delete_common_column_def", common_column_def.physical_name, common_column_def.table_group_id, nil, nil)
  end

  def register_create_table_def_history(table_def, issue_ids)
    changesets = table_def.previous_changes.slice("physical_name", "logical_name", "description")
    if table_def.column_defs.present?
      changesets["using_common_column_defs"] = ["", table_def.column_defs.map(&:physical_name).join(", ")]
    end
    self.register_history("table_def", "create_table_def", table_def.physical_name, table_def.id, changesets, issue_ids)
  end
end
