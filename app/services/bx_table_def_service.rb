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

  def update_common_column_def(common_column_def)
    common_column_def.update_attributes!(@input.params_for(:common_column_def, :table_group_id))
    BxTableDefHistoryService.new.register_update_common_column_def_history(common_column_def, @input.relational_issues)
    common_column_def
  end

  def delete_common_column_def(common_column_def, history_registration = true)
    common_column_def.destroy
    BxTableDefHistoryService.new.register_delete_common_column_def_history(common_column_def) if history_registration
  end

  def up_common_column_def_position(common_column_def)
    return unless common_column_def.can_up?

    another = BxCommonColumnDef.where(:table_group_id => common_column_def.table_group_id,
                                      :position_type => common_column_def.position_type,
                                      :position => common_column_def.position - 1).first
    common_column_def.position -= 1
    another.position += 1
    common_column_def.save!
    another.save!
  end

  def down_common_column_def_position(common_column_def)
    return unless common_column_def.can_down?

    another = BxCommonColumnDef.where(:table_group_id => common_column_def.table_group_id,
                                      :position_type => common_column_def.position_type,
                                      :position => common_column_def.position + 1).first
    common_column_def.position += 1
    another.position -= 1
    common_column_def.save!
    another.save!
  end

  def create_table_def
    table_def = BxTableDef.create!(@input.params_for(:table_def, :lock_version))
    valid_common_column_defs = BxCommonColumnDef.where(:table_group_id => table_def.table_group_id, :id => @input.using_common_column_defs)
    valid_common_column_defs.each.with_index(1) do |common_column_def, position|
      BxColumnDef.create!(:table_id => table_def.id,
                          :physical_name => common_column_def.physical_name,
                          :logical_name => common_column_def.logical_name,
                          :data_type_id => common_column_def.data_type_id,
                          :size => common_column_def.size,
                          :scale => common_column_def.scale,
                          :nullable => common_column_def.nullable,
                          :default_value => common_column_def.default_value,
                          :common_column_id => common_column_def.id,
                          :primary_key_number => common_column_def.primary_key_number,
                          :position => position)
    end
    BxTableDefHistoryService.new.register_create_table_def_history(table_def, @input.relational_issue_ids)
    table_def
  end
end

