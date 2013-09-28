# coding: utf-8
class BxCommonColumnDef < ActiveRecord::Base
  unloadable

  belongs_to :table_group, :class_name => "BxTableGroup", :foreign_key => :table_group_id
  belongs_to :data_type, :class_name => "BxDataType", :foreign_key => :data_type_id

  def header?
    position_type == "header"
  end

  def footer?
    position_type == "footer"
  end
end
