# coding: utf-8
class BxResourceNode < ActiveRecord::Base
  unloadable

  scope :roots, ->(project) {
    project_id = project.is_a?(Project) ? project.id : project
    where(:project_id => project_id, :parent_id => 0).order(:id)
  }
end
