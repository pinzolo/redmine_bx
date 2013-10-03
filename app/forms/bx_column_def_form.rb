# coding: utf-8
class BxColumnDefForm
  include Formup
  include BxIssuesRelation

  source :column_def, :aliases => { :table_id => :table_id,
                                    :physical_name => :physical_name,
                                    :logical_name => :logical_name,
                                    :data_type_id => :data_type_id,
                                    :size => :size,
                                    :scale => :scale,
                                    :nullable => :nullable,
                                    :default_value => :default_value,
                                    :reference_column_id => :reference_column_id,
                                    :primary_key_number => :primary_key_number,
                                    :note => :note,
                                    :lock_version => :lock_version }
  attr_accessor :base_column_def, :table_group_id, :reference_table_id

  validates :physical_name, :presence => true, :length => { :maximum => 200 }, :bx_column_def_physical_name_uniqueness => true
  validates :logical_name, :length => { :maximum => 200 }
  validates :data_type_id, :presence => true, :bx_data_type_id_presence => true
  validates :size, :numericality => { :only_integer => true, :greater_than => 0 }, :allow_blank => true
  validates :scale, :numericality => { :only_integer => true, :greater_than => 0 }, :allow_blank => true
  validates :primary_key_number, :numericality => { :only_integer => true, :greater_than => 0 }, :allow_blank => true

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.base_column_def = params[:base_column_def]
    self.table_group_id = params[:table_group_id]
    self.reference_table_id = params[:reference_table_id]
    self.reference_column_id ||= 0
  end
end

