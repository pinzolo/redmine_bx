# coding: utf-8
module BxService
  def initialize(input = nil)
    @input = input
  end

  def call_with_transaction(name, *args)
    reason = nil
    data = nil
    if @input.nil? || @input.valid?
      begin
        ActiveRecord::Base.transaction do
          data = self.__send__(name, *args)
        end
      rescue => ex
        Rails.logger.error(ex)
        Rails.logger.error(ex.backtrace.join("\n"))
        data = ex
        reason = ex.is_a?(ActiveRecord::StaleObjectError) ? :conflict : :error
      end
    else
      reason = :invalid_input
    end

    BxServiceResult.new(reason, data)
  end

  def method_missing(name, *args)
    base_method = name.to_s.chop
    if name.to_s.match(/!\Z/) && self.respond_to?(base_method)
      self.class.class_eval do
        define_method(name) do |*params|
          self.call_with_transaction(base_method, *params)
        end
      end
      self.__send__(name, *args)
    else
      super(name, *args)
    end
  end

  def respond_to_missing?(symbol, include_private)
    symbol.to_s.match(/!\Z/) && self.respond_to?(symbol.to_s.chop)
  end
end
