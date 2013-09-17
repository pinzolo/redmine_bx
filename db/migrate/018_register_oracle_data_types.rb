# coding: utf-8
class RegisterOracleDataTypes < ActiveRecord::Migration
  def change
    name = "Oracle"
    data_types = [
      { :name => "CHAR", :sizable => true, :scalable => false, :default_use => true},
      { :name => "VARCHAR2", :sizable => true, :scalable => false, :default_use => true},
      { :name => "NCHAR", :sizable => true, :scalable => false, :default_use => true},
      { :name => "NVARCHAR2", :sizable => true, :scalable => false, :default_use => true},
      { :name => "CLOB", :sizable => false, :scalable => false, :default_use => true},
      { :name => "BLOB", :sizable => false, :scalable => false, :default_use => true},
      { :name => "NUMBER", :sizable => true, :scalable => true, :default_use => true},
      { :name => "BINARY_FLOAT", :sizable => false, :scalable => false, :default_use => false},
      { :name => "BINARY_DOUBLE", :sizable => false, :scalable => false, :default_use => false},
      { :name => "DATE", :sizable => false, :scalable => false, :default_use => true},
      { :name => "TIMESTAMP", :sizable => false, :scalable => false, :default_use => true},
      { :name => "RAW", :sizable => true, :scalable => false, :default_use => false}
    ]
    ActiveRecord::Base.transaction do
      db = BxDatabase.create!(:name => name)
      data_types.each do |data_type|
        BxDataType.create!(data_type.merge(:database_id => db.id))
      end
    end
  end
end

