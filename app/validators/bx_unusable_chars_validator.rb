# coding: utf-8
class BxUnusableCharsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unusable_chars = options[:chars]
    if unusable_chars.present?
      if unusable_chars.any? { |c| value.to_s.index(c) }
        record.errors.add(attribute, I18n.t("activemodel.errors.messages.contains_unusable_chars", :chars => unusable_chars))
      end
    end
  end
end

