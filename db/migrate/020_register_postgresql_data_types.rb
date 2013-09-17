# coding: utf-8
class RegisterPostgresqlDataTypes < ActiveRecord::Migration
  def change
    name = "PostgreSQL"
    data_types = [
      { :name => 'smallint', :sizable => false, :scalable => false, :default_use => false },
      { :name => 'integer', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'bigint', :sizable => false, :scalable => false, :default_use => false },
      { :name => 'decimal', :sizable => true, :scalable => true, :default_use => false },
      { :name => 'numeric', :sizable => true, :scalable => true, :default_use => true },
      { :name => 'real', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'double precision', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'serial', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'bigserial', :sizable => false, :scalable => false, :default_use => false },
      { :name => 'money', :sizable => false, :scalable => false, :default_use => false },
      { :name => 'char', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'varchar', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'text', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'bytea', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'timestamp', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'timestamp with time zone', :sizable => true, :scalable => false, :default_use => false },
      { :name => 'date', :sizable => false, :scalable => false, :default_use => true },
      { :name => 'time', :sizable => true, :scalable => false, :default_use => true },
      { :name => 'time with time zone', :sizable => true, :scalable => false, :default_use => false },
      { :name => 'interval', :sizable => true, :scalable => false, :default_use => false },
      { :name => 'boolean', :sizable => false, :scalable => false, :default_use => true }
    ]
    ActiveRecord::Base.transaction do
      db = BxDatabase.create!(:name => name)
      data_types.each do |data_type|
        BxDataType.create!(data_type.merge(:database_id => db.id))
      end
    end
  end
end


