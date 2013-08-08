# coding: utf-8
module BxService
  extend ActiveSupport::Concern

  class Result
    def initialize(reason, data)
      @reason = reason
      @data = data
    end

    def success?
      @reason.nil?
    end

    def failure?
      !@reason.nil?
    end

    def form_invalid?
      @reason == :form_invalid
    end

    def conflict?
      @reason == :conflict
    end

    def error?
      @reason == :error
    end

    def data
      @data
    end
  end

  included do
    ms = public_instance_methods - Object.public_instance_methods
    puts ms.inspect
    ms.each do |m|
      dm = instance_method(m)
      undef_method(m)
      define_method m do |form|
        transaction(form, dm)
      end
    end
  end

  private
  def transaction(form, method)
    reason = nil
    data = nil
    if form.valid?
      begin
        ActiveRecord::Base.transaction do
          data = method.bind(self).call(form)
        end
      rescue ActiveRecord::StaleObjectError
        reason = :conflict
      rescue
        reason = :error
      end
    else
      reason = :form_invalid
    end

    ::Result.new(reason, data)
  end
end
