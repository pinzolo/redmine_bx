# coding: utf-8
class BxTemplate < ActiveRecord::Base
  unloadable

  belongs_to :project

  def self.available_target?(target)
    ["resource", "table_def"].include?(target)
  end
end
