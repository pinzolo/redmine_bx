# coding: utf-8
class BxTableGroup < ActiveRecord::Base
  unloadable

  belongs_to :database, :class_name => "BxDatabase", :foreign_key => :database_id
  has_many :table_defs, :class_name => "BxTableDef", :foreign_key => :table_group_id, :order => :physical_name
  has_many :data_types_rels, :class_name => "BxTableGroupDataType", :foreign_key => :table_group_id
  has_many :data_types, :through => :data_types_rels, :order => :name
  has_many :histories, :class_name => "BxHistory", :foreign_key => :source_id,
                       :conditions => Proc.new { ["target = ?", "table_group"] }, :include => :details
end
