# coding: utf-8
class BxTableDefPhysicalNameUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.base_table_def && record.base_table_def.physical_name == value

    if BxTableDef.exists?(:table_group_id => record.table_group_id, :physical_name => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.taken"))
    end
  end
end

