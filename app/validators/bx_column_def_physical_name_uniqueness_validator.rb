# coding: utf-8
class BxColumnDefPhysicalNameUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.base_column_def && record.base_column_def.physical_name == value

    if BxColumnDef.exists?(:table_id => record.table_id, :physical_name => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.taken"))
    end
  end
end

