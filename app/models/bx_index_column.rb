# coding: utf-8
class BxIndexColumn < ActiveRecord::Base
  unloadable

  belongs_to :column_def, :class_name => "BxColumnDef"
  belongs_to :index_def, :class_name => "BxIndexDef"
end
