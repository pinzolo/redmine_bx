# coding: utf-8
class BxIndexDefPhysicalNameUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if record.base_index_def && record.base_index_def.physical_name == value

    if BxIndexDef.exists?(:table_def_id => record.table_def_id, :physical_name => value)
      record.errors.add(attribute, I18n.t("activemodel.errors.messages.taken"))
    end
  end
end


