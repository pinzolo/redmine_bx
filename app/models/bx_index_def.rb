# coding: utf-8
class BxIndexDef < ActiveRecord::Base
  unloadable

  has_many :columns_rels, :class_name => "BxIndexColumn", :foreign_key => :index_def_id, :order => :position
  has_many :column_defs, :through => :columns_rels
end
