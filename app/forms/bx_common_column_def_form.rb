# coding: utf-8
class BxCommonColumnDefForm
  include Formup
  include BxIssuesRelation

  source :common_column_def, :aliases => { :table_group_id => :table_group_id,
                                           :physical_name => :physical_name,
                                           :logical_name => :logical_name,
                                           :data_type_id => :data_type_id,
                                           :size => :size,
                                           :scale => :scale,
                                           :nullable => :nullable,
                                           :default_value => :default_value,
                                           :primary_key_number => :primary_key_number,
                                           :position_type => :position_type,
                                           :note => :note,
                                           :lock_version => :lock_version }
  attr_accessor :base_common_column_def

  validates :physical_name, :presence => true, :length => { :maximum => 200 }, :bx_common_column_def_physical_name_uniqueness => true
  validates :logical_name, :length => { :maximum => 200 }
  validates :data_type_id, :presence => true, :bx_data_type_id_presence => true
  validates :size, :numericality => { :only_integer => true }, :allow_blank => true
  validates :scale, :numericality => { :only_integer => true }, :allow_blank => true
  validates :primary_key_number, :numericality => { :only_integer => true }, :allow_blank => true
  validates :position_type, :inclusion => { :in => ["header", "footer"] }

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.base_common_column_def = params[:base_common_column_def]
  end
end

