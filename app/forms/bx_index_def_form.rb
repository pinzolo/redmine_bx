# coding: utf-8
class BxIndexDefForm
  include Formup
  include BxIssuesRelation

  source :index_def, :aliases => { :table_def_id => :table_def_id,
                                   :physical_name => :physical_name,
                                   :logical_name => :logical_name,
                                   :unique => :unique,
                                   :note => :note,
                                   :lock_version => :lock_version }
  attr_accessor :base_index_def, :positions

  validates :physical_name, :presence => true, :length => { :maximum => 200 }, :bx_index_def_physical_name_uniqueness => true
  validates :logical_name, :length => { :maximum => 200 }
  validates :positions, :presence => true

  def initialize(params = {})
    self.positions = {}
    super(params)
  end

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.base_index_def = params[:base_index_def]
    self.positions = params[:positions]
    #params.each do |key, value|
    #  if /position_(?<column_def_id>\d+)\Z/ =~ key.to_s
    #    self.positions[column_def_id.to_i] = value
    #  end
    #end
  end
end


