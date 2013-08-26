# coding: utf-8
class BxResourceBranchCodeUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if BxResourceBranch.exists?(:root_node_id => record.root_node_id, :code => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.taken"))
    end
  end
end

