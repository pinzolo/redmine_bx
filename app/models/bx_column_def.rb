# coding: utf-8
class BxColumnDef < ActiveRecord::Base
  unloadable

  belongs_to :table_def, :class_name => "BxTableDef"
  belongs_to :data_type, :class_name => "BxDataType"
  belongs_to :common_column_def, :class_name => "BxCommonColumnDef"
  belongs_to :reference_column_def, :class_name => "BxColumnDef"

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
