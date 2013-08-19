# coding: utf-8
class BxHistoryService
  include BxService

  def create_resource_history(operation_type, resource)
    self.create("resource", operation_type, resource)
  end

  def create(target, operation_type, source)
    history = BxHistory.new(:target => target, :operation_type => operation_type, :source_id => source.id)
  end
end
