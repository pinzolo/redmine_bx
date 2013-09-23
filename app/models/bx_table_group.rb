# coding: utf-8
class BxTableGroup < ActiveRecord::Base
  unloadable

  has_many :table_defs, :class_name => "BxTableDef", :foreign_key => :table_group_id, :order => :physical_name
  has_many :data_types_rels, :class_name => "BxTableGroupDataType", :foreign_key => :table_group_id
  has_many :data_types, :through => :data_types_rels, :order => :name
end
