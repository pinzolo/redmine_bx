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
  validates :positions, :presence => true, :bx_values_numericality => { :ignore_blank => true }, :bx_values_ordering => { :ignore_blank => true }

  def initialize(params = {})
    self.positions = {}
    super(params)
  end

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.base_index_def = params[:base_index_def]
    keys = params[:positions].keys.select { |k| /\A\d+\z/ =~ k.to_s }
    valid_keys = BxColumnDef.where(:table_def_id => self.table_def_id, :id => keys).pluck(:id).map(&:to_s)
    params[:positions].each do |key, value|
      if value.present? && valid_keys.include?(key.to_s)
        self.positions[key.to_i] = value
      end
    end
  end
end


