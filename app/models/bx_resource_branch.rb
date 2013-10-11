# coding: utf-8
class BxResourceBranch < ActiveRecord::Base
  unloadable

  belongs_to :category, :class_name => "BxResourceCategory"
end
