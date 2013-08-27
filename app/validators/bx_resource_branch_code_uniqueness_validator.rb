# coding: utf-8
class BxResourceBranchCodeUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if BxResourceBranch.exists?(:category_id => record.category_id, :code => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.taken"))
    end
  end
end

