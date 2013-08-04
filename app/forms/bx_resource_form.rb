# coding: utf-8
class BxResourceForm
  include Formup

  source :resource, :attributes => [:id],
                    :aliases => {
                      :project_id => :project_id,
                      :parent_id => :parent_id,
                      :root_node_id => :root_id,
                      :summary => :summary,
                      :code => :code,
                      :lock_version => :lock_version
                    }

  def root?
    self.resource_root_nod_id.zero?
  end
end
