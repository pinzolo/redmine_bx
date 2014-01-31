# coding: utf-8
class BxAdminService
  include BxService

  def create_database
    database = BxDatabase.create!(@input.params_for(:database, :lock_version))
    if @input.copy_source_id.present?
      BxDataType.where(:database_id => @input.copy_source_id).each do |src_data_type|
        BxDataType.create!(:name => src_data_type.name,
                           :database_id => database.id,
                           :sizable => src_data_type.sizable,
                           :scalable => src_data_type.scalable,
                           :default_use => src_data_type.default_use)
      end
    end
    database
  end

  def update_database(database)
    database.update_attributes!(@input.params_for(:database))
  end

  def delete_database(database)
    BxDataType.delete_all(:database_id => database.id)
    database.destroy
  end
end
