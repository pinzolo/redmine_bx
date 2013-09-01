# coding: utf-8
class BxResourceCategoryPresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless BxResourceCategory.exists?(:id => record.category_id, :project_id => record.project_id)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.category_not_in_project", :id => record.category_id))
    end
  end
end
