# coding: utf-8
module BxService
  extend ActiveSupport::Concern

  module ClassMethods
    def method_added(name)
      unless name.match(/!\Z/)
        define_method("#{name}!") do |*args|
          self.call_with_transaction(name, form, *args)
        end
      end
    end
  end

  private
  def call_with_transaction(name, *args)
    form = args.first unless args.empty?

    if form.nil? || form.valid?
      begin
        ActiveRecord::Base.transaction do
          data = self.__send__(name, *args)
        end
      rescue => ex
        Rails.logger.error(ex)
        reason = ex.is_a?(ActiveRecord::StaleObjectError) ? :conflict : :error
      end
    else
      reason = :form_invalid
    end

    BxServiceResult.new(reason, data)
  end
end
