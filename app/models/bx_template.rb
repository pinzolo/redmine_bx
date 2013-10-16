# coding: utf-8
class BxTemplate < ActiveRecord::Base
  unloadable

  belongs_to :project

  AVAILABLE_TARGETS = ["resource", "table_def"]

  def self.available_target?(target)
    AVAILABLE_TARGETS.include?(target)
  end
end
