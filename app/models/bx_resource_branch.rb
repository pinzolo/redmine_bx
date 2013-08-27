# coding: utf-8
class BxResourceBranch < ActiveRecord::Base
  unloadable

  belongs_to :category, :class_name => "BxResourceCategory", :foreign_key => :category_id
end
