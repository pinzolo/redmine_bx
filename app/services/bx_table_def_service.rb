# coding: utf-8
class BxTableDefService
  include BxService

  def create_table_group
    table_group = BxTableGroup.create!(@input.params_for(:table_group, :lock_version))
    valid_data_type_ids = BxDataType.where(:database_id => table_group.database_id).pluck(:id)
    @input.data_types.each do |data_type|
      if valid_data_type_ids.include?(data_type.to_i)
        BxTableGroupDataType.create!(:data_type_id => data_type, :table_group_id => table_group.id)
      end
    end
    BxTableDefHistoryService.new.register_create_table_group_history(table_group, @input.relational_issue_ids)
    table_group
  end

  def create_common_column_def
    common_column_def = BxCommonColumnDef.new(@input.params_for(:common_column_def, :lock_version))
    base_defs = common_column_def.header? ? common_column_def.table_group.common_header_column_defs : common_column_def.table_group.common_footer_column_defs
    common_column_def.position = base_defs.length + 1
    common_column_def.save!
    BxTableDefHistoryService.new.register_create_common_column_def_history(common_column_def, @input.relational_issues)
  end
end

