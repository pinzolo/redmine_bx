# coding: utf-8
module BxIssuesRelation
  extend ActiveSupport::Concern

  included do
    attr_accessor :relational_issues
  end

  def relational_issue_ids
    return [] if self.relational_issues.blank?

    ids = self.relational_issues.split(' ').map { |item| item.split(',') }.flatten.delete_if { |item| item.blank? }
    normalized_ids = ids.map do |item|
      if item.match(/#\d+/)
        item[1..item.length]
      elsif item.match(/\d+/)
        item
      else
        nil
      end
    end.compact
    Issue.where(:id => normalized_ids).pluck(:id).sort
  end
end
