# coding: utf-8
class BxAdminService
  include BxService

  def create_database
    database = BxDatabase.create!(@input.params_for(:database, :lock_version))
    if @input.copy_source_id.present?
      BxDataType.where(:database_id => @input.copy_source_id).tap { |dt| Rails.logger.debug("data_type : #{dt.to_a}") }.each do |src_data_type|
        BxDataType.create!(:name => src_data_type.name,
                           :database_id => database.id,
                           :sizable => src_data_type.sizable,
                           :scalable => src_data_type.scalable,
                           :default_use => src_data_type.default_use)
      end
    end
    database
  end
end
