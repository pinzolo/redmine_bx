# coding: utf-8
class BxDatabase < ActiveRecord::Base
  unloadable

  has_many :data_types, :class_name => "BxDataType", :foreign_key => :database_id, :order => :name
end
