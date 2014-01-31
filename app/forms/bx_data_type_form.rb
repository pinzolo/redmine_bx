# coding: utf-8
class BxDataTypeForm
  include Formup

  source :data_type, :aliases => { :name => :name,
                                   :database_id => :database_id,
                                   :sizable => :sizable,
                                   :scalable => :scalable,
                                   :default_use => :default_use,
                                   :lock_version => :lock_version }
  attr_accessor :base_data_type

  validates :name, :presence => true, :length => { :maximum => 200 }, :bx_data_type_name_uniqueness => true

  def handle_extra_params(params)
    self.base_data_type = params[:base_data_type]
  end
end
