# coding: utf-8
class RegisterMysqlDataTypes < ActiveRecord::Migration
  def change
    name = "MySQL"
    data_types = [
      { :name => 'TINYINT', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'SMALLINT', :sizable => true, :scalable => false, :default_use => false },
      { :name => 'MEDIUMINT', :sizable => true, :scalable => false, :default_use => false },
      { :name => 'INT', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'BIGINT', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'FLOAT', :sizable => true, :scalable => true, :default_use => false },
      { :name => 'DOUBLE', :sizable => true, :scalable => true, :default_use => true },
      { :name => 'REAL', :sizable => true, :scalable => true, :default_use => false },
      { :name => 'DOUBLE PRECISION', :sizable => true, :scalable => true, :default_use => false },
      { :name => 'DECIMAL', :sizable => true, :scalable => true, :default_use => true },
      { :name => 'NUMERIC', :sizable => true, :scalable => true, :default_use => false },
      { :name => 'FIXED', :sizable => true, :scalable => true, :default_use => false },
      { :name => 'BOOLEAN', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'BIT', :sizable => true, :scalable => false, :default_use => false },
      { :name => 'DATE', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'DATETIME', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'TIME', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'TIMESTAMP', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'YEAR', :sizable => false, :scalable => false, :default_use => false },
      { :name => 'CHAR', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'VARCHAR', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'TEXT', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'MEDIUMTEXT', :sizable => false, :scalable => false, :default_use => false },
      { :name => 'LONGTEXT', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'BLOB', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'MEDIUMBLOB', :sizable => false, :scalable => false, :default_use => false },
      { :name => 'LONGBLOB', :sizable => false, :scalable => false, :default_use => true }
    ]
    ActiveRecord::Base.transaction do
      db = BxDatabase.create!(:name => name)
      data_types.each do |data_type|
        BxDataType.create!(data_type.merge(:database_id => db.id))
      end
    end
  end
end


