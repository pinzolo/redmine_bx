# coding: utf-8
class BxHistoryService
  include BxService

  def register_history(target, operation, key, source_id, changesets, issue_ids)
    history = BxHistory.create!(:target => target,
                                :operation_type => operation.split("_").first,
                                :operation => operation,
                                :key => key,
                                :source_id => source_id,
                                :changed_by => User.current.id,
                                :changed_at => Time.now)
    self.register_history_details(history, changesets) if changesets.present?
    self.register_history_issues(history, issue_ids) if issue_ids.present?
  end

  def register_history_details(history, changesets)
    changesets.each do |attr, changeset|
      BxHistoryDetail.create!(:history_id => history.id,
                              :property => attr,
                              :old_value => changeset.first,
                              :new_value => changeset.last)
    end
  end

  def register_history_issues(history, issue_ids)
    BxHistoryIssue.delete_all(:history_id => history.id)
    valid_issue_ids = Issue.where(:id => issue_ids).pluck(:id)
    valid_issue_ids.each do |issue_id|
      BxHistoryIssue.create!(:history_id => history.id, :issue_id => issue_id)
    end
  end
end
