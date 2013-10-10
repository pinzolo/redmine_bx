# coding: utf-8
class BxValuesOrderingValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    values = if value.is_a?(Hash)
               value.values
             elsif value.is_a?(Array)
               value
             end
    values = values.select { |v| v.present? } if values && options[:ignore_blank]
    return if values.blank?

    valid_values = (1..values.size).to_a.map(&:to_s)
    unless values.all? { |v| valid_values.include?(v.to_s) }
      message = I18n.t("activemodel.errors.messages.invalid_order")
      unless record.errors.messages.key?(attribute) && record.errors.messages[attribute].include?(message)
        record.errors.add(attribute, message)
      end
    end
  end
end

