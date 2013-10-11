# coding: utf-8
class BxTableGroupDataType < ActiveRecord::Base
  unloadable

  belongs_to :table_group, :class_name => "BxTableGroup"
  belongs_to :data_type, :class_name => "BxDataType"
end
