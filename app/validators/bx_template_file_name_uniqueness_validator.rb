# coding: utf-8
class BxResourceBranchCodeUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.base_template && record.base_template.file_name == value

    if BxTemplate.exists?(:project_id => record.project_id, :file_name => value)
      message = I18n.t("activemodel.errors.messages.taken")
      unless record.errors.messages.key?(attribute) && record.errors.messages[attribute].include?(message)
        record.errors.add(attribute, message)
      end
    end
  end
end

