# coding: utf-8
class BxResourceForm
  include Formup
  include BxIssuesRelation

  source :resource, :aliases => { :project_id => :project_id,
                                  :category_id => :category_id,
                                  :parent_id => :parent_id,
                                  :code => :code,
                                  :summary => :summary,
                                  :lock_version => :lock_version }
  attr_accessor :branch_values, :branches, :base_resource

  validates :category_id, :presence => true, :bx_resource_category_presence => true
  validates :parent_id, :presence => true, :bx_resource_parent_presence_or_zero => true
  validates :code, :presence => true, :length => { :maximum => 200 }, :bx_resource_code_uniqueness => true, :bx_unusable_chars => { :chars => [":"] }
  validates :summary, :length => { :maximum => 200 }

  def initialize(params = {})
    self.branch_values = {}
    super(params)
    if self.parent_id.to_i.zero?
      self.parent_id = 0
    else
      self.category_id = BxResourceNode.where(:id => self.parent_id).first.try(:category_id)
    end
    self.branches = BxResourceCategory.where(:id => self.category_id).first.try(:branches)
  end

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.base_resource = params[:base_resource]
    params.each do |key, value|
      if /branch_value_(?<branch_id>\d+)\Z/ =~ key.to_s
        self.branch_values[branch_id.to_i] = value
      end
    end
  end
end

