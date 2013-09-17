# coding: utf-8
class BxTableDef < ActiveRecord::Base
  unloadable

  belongs_to :table_group, :class_name => "BxTableGroup", :foreign_key => :table_group_id
  has_many :column_defs, :class_name => "BxColumnDef", :foreign_key => :table_id, :order => :physical_name
  has_many :index_defs, :class_name => "BxIndexDef", :foreign_key => :table_id, :order => :physical_name, :include => :columns
end
