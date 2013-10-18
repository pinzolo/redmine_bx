# coding: utf-8
class BxTableDefHistoryService < BxHistoryService
  def register_create_table_group_history(table_group, issue_ids)
    prev_changes = table_group.previous_changes
    changesets = prev_changes.slice("name")
    changesets["database"] = ["", table_group.database.name] if prev_changes.key?("database_id")
    data_types = table_group.data_types.map(&:name).join(", ")
    changesets["data_types"] = ["", data_types]
    changesets.merge!(prev_changes.slice("description"))
    self.register_history("table_group", "create_table_group", table_group.name, table_group.id, changesets, issue_ids)
  end

  def register_update_table_group_history(table_group, old_data_types, issue_ids)
    prev_changes = table_group.previous_changes
    changesets = prev_changes.slice("name")
    if prev_changes.key?("database_id")
      prev_database = BxDatabase.find(prev_changes["database_id"].first)
      changesets["database"] = [prev_database.name, table_group.database.name]
    end
    prev_data_type_names = old_data_types.map(&:name).join(", ")
    new_data_type_names = table_group.data_types(true).map(&:name).join(", ")
    if prev_data_type_names != new_data_type_names
      changesets["data_types"] = [prev_data_type_names, new_data_type_names]
    end
    changesets.merge!(prev_changes.slice("description"))
    self.register_history("table_group", "update_table_group", table_group.name, table_group.id, changesets, issue_ids)
  end

  def register_create_common_column_def_history(common_column_def, issue_ids)
    changesets = common_column_def.previous_changes.slice("physical_name", "logical_name")
    if common_column_def.previous_changes.key?("data_type_id")
      changesets["data_type"] = ["", common_column_def.data_type.name]
    end
    changesets = changesets.merge(common_column_def.previous_changes.slice("size", "scale", "nullable", "default_value", "primary_key_number", "position_type", "note"))
    self.register_history("table_group", "create_common_column_def", common_column_def.physical_name, common_column_def.table_group.id, changesets, issue_ids)
  end

  def register_update_common_column_def_history(common_column_def, issue_ids)
    changesets = common_column_def.previous_changes.slice("physical_name", "logical_name", "data_type_id")
    if common_column_def.previous_changes.key?("data_type_id")
      prev_data_type = BxDataType.find(changesets["data_type_id"].first)
      changesets["data_type"] = [prev_data_type.name, common_column_def.data_type.name]
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

  def register_update_table_def_history(table_def, issue_ids)
    changesets = table_def.previous_changes.slice("physical_name", "logical_name", "description")
    self.register_history("table_def", "update_table_def", table_def.physical_name, table_def.id, changesets, issue_ids)
  end

  def register_delete_table_def_history(table_def)
    self.register_history("table_group", "delete_table_def", table_def.physical_name, table_def.table_group_id, nil, nil)
  end

  def register_create_column_def_history(column_def, issue_ids)
    prev_changes = column_def.previous_changes
    changesets = prev_changes.slice("physical_name", "logical_name")
    changesets["data_type"] = ["", column_def.data_type.name] if prev_changes.key?("data_type_id")
    changesets.merge!(prev_changes.slice("size", "scale", "nullable", "default_value"))
    if column_def.reference_column_def && prev_changes.key?("reference_column_def_id")
      changesets["reference_column_def"] = ["", column_def.reference_column_def.full_physical_name]
    end
    changesets.merge!(prev_changes.slice("primary_key_number", "note"))
    self.register_history("table_def", "create_column_def", column_def.physical_name, column_def.table_def_id, changesets, issue_ids)
  end

  def register_update_column_def_history(column_def, issue_ids)
    prev_changes = column_def.previous_changes
    changesets = prev_changes.slice("physical_name", "logical_name")
    if prev_changes.key?("data_type_id")
      prev_data_type = BxDataType.find(prev_changes["data_type_id"].first)
      changesets["data_type"] = [prev_data_type.name, column_def.data_type.name]
    end
    changesets.merge!(prev_changes.slice("size", "scale", "nullable", "default_value"))
    if prev_changes.key?("reference_column_def_id")
      prev_id = prev_changes["reference_column_def_id"].first
      prev_value = prev_id.to_i.zero? ? "" : BxColumnDef.find(prev_id).full_physical_name
      new_value = column_def.reference_column_def.try(:full_physical_name) || ""
      changesets["reference_column_def"] = [prev_value, new_value]
    end
    changesets.merge!(prev_changes.slice("primary_key_number", "note"))
    self.register_history("table_def", "update_column_def", column_def.physical_name, column_def.table_def_id, changesets, issue_ids)
  end

  def register_delete_column_def_history(column_def)
    self.register_history("table_def", "delete_column_def", column_def.physical_name, column_def.table_def_id, nil, nil)
  end

  def register_create_index_def_history(index_def, issue_ids)
    changesets = index_def.previous_changes.slice("physical_name", "logical_name", "unique")
    changesets["column_defs"] = ["", index_def.column_defs.map(&:physical_name).join(", ")]
    changesets.merge!(index_def.previous_changes.slice("note"))
    self.register_history("table_def", "create_index_def", index_def.physical_name, index_def.table_def_id, changesets, issue_ids)
  end

  def register_update_index_def_history(index_def, old_column_defs, issue_ids)
    changesets = index_def.previous_changes.slice("physical_name", "logical_name", "unique")
    changesets["column_defs"] = [old_column_defs.map(&:physical_name).join(", "), index_def.column_defs(true).map(&:physical_name).join(", ")]
    changesets.merge!(index_def.previous_changes.slice("note"))
    self.register_history("table_def", "update_index_def", index_def.physical_name, index_def.table_def_id, changesets, issue_ids)
  end

  def register_delete_index_def_history(index_def)
    self.register_history("table_def", "delete_index_def", index_def.physical_name, index_def.table_def_id, nil, nil)
  end
end
