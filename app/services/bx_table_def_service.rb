# coding: utf-8
class BxTableDefService
  include BxService

  # table group {{{
  def create_table_group
    table_group = BxTableGroup.create!(@input.params_for(:table_group, :lock_version))
    create_table_group_data_types!(table_group)
    BxTableDefHistoryService.new.register_create_table_group_history(table_group, @input.relational_issue_ids)
    table_group
  end

  def update_table_group(table_group)
    old_data_types = table_group.data_types.to_a
    table_group.update_attributes!(@input.params_for(:table_group, :project_id))
    BxTableGroupDataType.delete_all(:table_group_id => table_group.id)
    create_table_group_data_types!(table_group)
    BxTableDefHistoryService.new.register_update_table_group_history(table_group, old_data_types, @input.relational_issue_ids)
    table_group
  end
  # }}}

  # common column {{{
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
    transpose_position!(common_column_def, another)
  end

  def down_common_column_def_position(common_column_def)
    return unless common_column_def.can_down?

    another = BxCommonColumnDef.where(:table_group_id => common_column_def.table_group_id,
                                      :position_type => common_column_def.position_type,
                                      :position => common_column_def.position + 1).first
    transpose_position!(common_column_def, another)
  end
  # }}}

  # table def {{{
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

  def update_table_def(table_def)
    table_def.update_attributes!(@input.params_for(:table_def, :table_group_id))
    BxTableDefHistoryService.new.register_update_table_def_history(table_def, @input.relational_issue_ids)
    table_def
  end
  # }}}

  # column def {{{
  def create_column_def
    column_def = BxColumnDef.new(@input.params_for(:column_def, :lock_version))
    existing_column_defs = BxColumnDef.where(:table_id => column_def.table_id).order(:position)
    last_column_def_without_footer = existing_column_defs.select { |c| !c.common_column_def.try(:footer?) }.last
    column_def.position = last_column_def_without_footer ? last_column_def_without_footer.position + 1 : 1
    existing_column_defs.each do |c|
      if c.position > last_column_def_without_footer.position
        c.position += 1
        c.save!
      end
    end
    column_def.save!
    BxTableDefHistoryService.new.register_create_column_def_history(column_def, @input.relational_issues)
  end

  def update_column_def(column_def)
    column_def.update_attributes!(@input.params_for(:column_def, :table_id))
    BxTableDefHistoryService.new.register_update_column_def_history(column_def, @input.relational_issues)
    column_def
  end

  def delete_column_def(column_def, history_registration = true)
    column_def.destroy
    BxTableDefHistoryService.new.register_delete_column_def_history(column_def) if history_registration
  end

  def up_column_def_position(column_def)
    return unless column_def.can_up?

    another = BxColumnDef.where(:table_id => column_def.table_id, :position => column_def.position - 1).first
    transpose_position!(column_def, another)
  end

  def down_column_def_position(column_def)
    return unless column_def.can_down?

    another = BxColumnDef.where(:table_id => column_def.table_id, :position => column_def.position + 1).first
    transpose_position!(column_def, another)
  end
  # }}}

  private
  def transpose_position!(one, another)
    one.position, another.position = another.position, one.position
    one.save!
    another.save!
  end

  def create_table_group_data_types!(table_group)
    valid_data_type_ids = BxDataType.where(:database_id => table_group.database_id).pluck(:id)
    @input.data_types.each do |data_type|
      if valid_data_type_ids.include?(data_type.to_i)
        BxTableGroupDataType.create!(:data_type_id => data_type, :table_group_id => table_group.id)
      end
    end
  end
end

