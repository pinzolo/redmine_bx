# coding: utf-8
class BxDataTypeNameUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.base_data_type && record.data_type.name == value

    if BxDataType.exists?(:database_id => record.database_id, :name => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.taken"))
    end
  end
end


