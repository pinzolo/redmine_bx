# coding: utf-8
class BxResourceCodeUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if BxResourceNode.exists?(:project_id => record.project_id, :parent_id => record.parent_id, :code => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.taken"))
    end
  end
end
