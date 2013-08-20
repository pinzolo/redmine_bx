# coding: utf-8
class BxHistoryService
  include BxService

  def self.target(t)
    @@target = t.to_s
  end

  def register_create_history(source, issue_ids)
    self.register_history("create", source, issue_ids, nil)
  end

  def register_update_history(source, issue_ids, old_values)
    self.regsiter_history("update", source, issue_ids, old_values)
  end

  def register_history(operation_type, source, issue_ids, old_values)
    history = BxHistory.create!(:target => @@target,
                                :operation_type => operation_type,
                                :source_id => source.id,
                                :changed_by => User.current.id,
                                :changed_at => Time.now)
    self.register_history_issues(history, issue_ids) if issue_ids.present?
    self.register_history_details(history, source, old_values) if old_values.present?
  end

  def register_history_details(history, source, old_values)
    # TODO: implements when update feature will be implemented.
  end

  def register_history_issues(history, issue_ids)
    BxHistoryIssue.delete_all(:history_id => history.id)
    valid_issue_ids = Issue.where(:id => issue_ids).pluck(:id)
    valid_issue_ids.each do |issue_id|
      BxHistoryIssue.create!(:history_id => history.id, :issue_id => issue_id)
    end
  end
end
