# coding: utf-8
class BxValuesNumericalityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    values = if value.is_a?(Hash)
               value.values
             elsif value.is_a?(Array)
               value
             end
    values = values.select { |v| v.present? } if values && options[:ignore_blank]
    return if values.blank?

    unless values.all? { |v| /\A\d+\z/ =~ v.to_s }
      message = I18n.t("activemodel.errors.messages.contains_not_a_number")
      unless record.errors.messages.key?(attribute) && record.errors.messages[attribute].include?(message)
        record.errors.add(attribute, message)
      end
    end
  end
end
