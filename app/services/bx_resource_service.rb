# coding: utf-8
class BxResourceService
  include BxService

  def create_root
    params = @input.params_for(:resource).merge(:project_id => @input.project.id, :parent_id => BxResourceNode::PARENT_ID_OF_ROOT)
    root = BxResourceNode.new(params)
    root.save!
    root.root_node_id = root.id
    root.save!
  end
end
