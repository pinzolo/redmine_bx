# coding: utf-8
class RegisterSqlServerDataTypes < ActiveRecord::Migration
  def change
    name = "SQL Server"
    data_types = [
      {:name => 'bigint', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'int', :sizable => false, :scalable => false, :default_use => true},
      {:name => 'smallint', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'tinyint', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'numeric', :sizable => true, :scalable => true, :default_use => false},
      {:name => 'decimal', :sizable => true, :scalable => true, :default_use => true},
      {:name => 'smallmoney', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'money', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'float', :sizable => false, :scalable => false, :default_use => true},
      {:name => 'real', :sizable => false, :scalable => false, :default_use => true},
      {:name => 'bit', :sizable => false, :scalable => false, :default_use => true},
      {:name => 'date', :sizable => false, :scalable => false, :default_use => true},
      {:name => 'time', :sizable => true, :scalable => false, :default_use => true},
      {:name => 'datetime', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'datetime2', :sizable => true, :scalable => false, :default_use => true},
      {:name => 'smalldatetime', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'datetimeoffset', :sizable => true, :scalable => false, :default_use => false},
      {:name => 'char', :sizable => true, :scalable => false, :default_use => true},
      {:name => 'varchar', :sizable => true, :scalable => false, :default_use => true},
      {:name => 'text', :sizable => false, :scalable => false, :default_use => true},
      {:name => 'binary', :sizable => true, :scalable => false, :default_use => false},
      {:name => 'varbinary', :sizable => true, :scalable => false, :default_use => true},
      {:name => 'image', :sizable => false, :scalable => false, :default_use => false},
      {:name => 'timestamp', :sizable => false, :scalable => false, :default_use => true},
      {:name => 'uniqueidentifier', :sizable => false, :scalable => false, :default_use => true}
    ]
    ActiveRecord::Base.transaction do
      db = BxDatabase.create!(:name => name)
      data_types.each do |data_type|
        BxDataType.create!(data_type.merge(:database_id => db.id))
      end
    end
  end
end

