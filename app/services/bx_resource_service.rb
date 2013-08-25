# coding: utf-8
class BxResourceService
  include BxService

  def create_root
    params = @input.params_for(:resource).merge(:project_id => @input.project.id, :parent_id => BxResourceNode::PARENT_ID_OF_ROOT)
    root = BxResourceNode.create!(params)
    BxResourceHistoryService.new.register_create_root_history(root, @input.relational_issue_ids)
    root.root_node_id = root.id
    root.save!
    root
  end
end
