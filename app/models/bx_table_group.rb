# coding: utf-8
class BxTableGroup < ActiveRecord::Base
  unloadable

  has_many :table_defs, :class_name => "BxTableDef", :foreign_key => :table_group_id, :order => :physical_name
end
