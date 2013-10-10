# coding: utf-8
class BxTableDef < ActiveRecord::Base
  unloadable

  belongs_to :table_group, :class_name => "BxTableGroup", :foreign_key => :table_group_id
  has_many :column_defs, :class_name => "BxColumnDef", :foreign_key => :table_def_id, :order => :position, :include => :common_column_def
  has_many :index_defs, :class_name => "BxIndexDef", :foreign_key => :table_def_id, :order => :physical_name, :include => :column_defs
  has_many :histories, :class_name => "BxHistory", :foreign_key => :source_id,
                       :conditions => Proc.new { ["target = ?", "table_def"] }, :include => [:details, :issues]
end
