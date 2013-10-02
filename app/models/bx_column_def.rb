# coding: utf-8
class BxColumnDef < ActiveRecord::Base
  unloadable

  belongs_to :table_def, :class_name => "BxTableDef", :foreign_key => :table_id
  belongs_to :data_type, :class_name => "BxDataType", :foreign_key => :data_type_id
  belongs_to :common_column_def, :class_name => "BxCommonColumnDef", :foreign_key => :common_column_id
  belongs_to :reference_column_def, :class_name => "BxColumnDef", :foreign_key => :reference_column_id

  def full_physical_name
    "#{table_def.physical_name}.#{physical_name}"
  end

  def can_up?
    self != table_def.column_defs.first
  end

  def can_down?
    self != table_def.column_defs.last
  end
end
