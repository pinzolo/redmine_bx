# coding: utf-8
class BxTemplateForm
  include Formup
  include BxIssuesRelation

  source :template, :aliases => { :name => :name,
                                  :target => :target,
                                  :file_name => :file_name,
                                  :content => :content,
                                  :allow_direct => :allow_direct
                                  :lock_version => :lock_version }

  attr_accessor :base_template

  validates :name, :presence => true, :length => { :maximum => 200 }
  validates :file_name, :presence => true, :length => { :maximum => 200 }, :bx_template_file_name_uniqueness => true

  def handle_extra_params(params)
    self.relational_issues = params[:relational_issues]
    self.base_tempalte = params[:base_template]
  end
end

