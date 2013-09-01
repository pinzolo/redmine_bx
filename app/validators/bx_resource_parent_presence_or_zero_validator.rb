# coding: utf-8
class BxResourceParentPresenceOrZeroValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.parent_id.to_i.zero?

    unless BxResourceNode.exists?(:id => record.parent_id, :project_id => record.project_id)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.parent_not_in_project", :id => record.parent_id))
    end
  end
end

