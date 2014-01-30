# coding: utf-8
class BxDatabaseForm
  include Formup

  source :database, :aliases => { :name => :name, :lock_version => :lock_version }
  attr_accessor :copy_source_id

  validates :name, :presence => true, :length => { :maximum => 200 }

  def handle_extra_params(params)
    self.copy_source_id = params[:copy_source_id]
  end
end
