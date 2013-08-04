# coding: utf-8
class BxRootResourceForm
  include Formup

  source :resource, :attributes => [:id, :summary, :code]

  attr_accessor :branch_names, :branch_codes

  validates :resource_code, :presence => true
  validates :resource_summary, :presence => true

  def handle_extra_params(params)
    self.branch_codes = []
    self.branch_names = []
    params.each do |k, v|
      if k.to_s.start_with?("branch_name_")
        no = k.to_s.slice("branch_name_".length..k.to_s.length)
        self.branch_names << v
        self.branch_codes << params["branch_code_#{no}"]
      end
    end
  end
end
