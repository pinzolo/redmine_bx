# coding: utf-8
class BxServiceResult
  attr_reader :data

  def initialize(reason, data)
    @reason = reason
    @data = data
  end

  def success?
    @reason.nil?
  end

  def failure?
    !self.success?
  end

  def invalid_input?
    @reason == :invalid_input
  end

  def conflict?
    @reason == :conflict
  end

  def error?
    @reason == :error
  end
end
