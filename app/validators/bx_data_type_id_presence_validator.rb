# coding: utf-8
class BxDataTypeIdPresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless BxTableGroupDataType.exists?(:table_group_id => record.table_group_id, :data_type_id => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.inclusion"))
    end
  end
end


