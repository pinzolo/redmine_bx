# coding: utf-8
class BxIndexColumn < ActiveRecord::Base
  unloadable

  belongs_to :column_def, :class_name => "BxColumnDef", :foreign_key => :column_def_id
  belongs_to :index_def, :class_name => "BxIndexDef", :foreign_key => :index_def_id
end
