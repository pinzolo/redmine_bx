# coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BxHistoryService do
  fixtures :users, :bx_histories, :bx_history_details, :bx_history_issues

  let(:current_time) { Time.local(2013, 11, 16, 9, 0, 0) }
  before(:each) do
    Time.stub(:now).and_return(current_time)
    user = User.find(2)
    User.stub(:current).and_return(user)
  end

  shared_examples_for "history registration" do
    it "returns registered history" do
      expect(history).to be_a_instance_of(BxHistory)
    end
    it "registers 'test_target' as target" do
      expect(history.target).to eq "test_target"
    end
    it "registers 'test' as operation_type" do
      expect(history.operation_type).to eq "test"
    end
    it "registers 'test_operation' as operation" do
      expect(history.operation).to eq "test_operation"
    end
    it "registers 'test_key' as key" do
      expect(history.key).to eq "test_key"
    end
    it "registers current user's id as changed_by" do
      expect(history.changed_by).to eq 2
    end
    it "registers current time as changed_at" do
      expect(history.changed_at).to eq current_time
    end
  end

  shared_examples_for "history detail single registration" do
    let(:detail) { BxHistoryDetail.where(:history_id => history.id).first }

    it "registers 'foo' as property" do
      expect(detail.property).to eq "foo"
    end
    it "registers '111' as old_value" do
      expect(detail.old_value).to eq "111"
    end
    it "registers '222' as property" do
      expect(detail.new_value).to eq "222"
    end
  end

  shared_examples_for "history detail multi registration" do
    let(:detail1) { BxHistoryDetail.where(:history_id => history.id).first }
    let(:detail2) { BxHistoryDetail.where(:history_id => history.id)[1] }
    let(:detail3) { BxHistoryDetail.where(:history_id => history.id).last }

    it "registers 'foo' as property of first detail" do
      expect(detail1.property).to eq "foo"
    end
    it "registers '111' as old_value of first detail" do
      expect(detail1.old_value).to eq "111"
    end
    it "registers '222' as property of first detail" do
      expect(detail1.new_value).to eq "222"
    end
    it "registers 'bar' as property of second detail" do
      expect(detail2.property).to eq "bar"
    end
    it "registers '333' as old_value of second detail" do
      expect(detail2.old_value).to eq "333"
    end
    it "registers '444' as property of second detail" do
      expect(detail2.new_value).to eq "444"
    end
    it "registers 'baz' as property of last detail" do
      expect(detail3.property).to eq "baz"
    end
    it "registers '555' as old_value of last detail" do
      expect(detail3.old_value).to eq "555"
    end
    it "registers '666' as property of last detail" do
      expect(detail3.new_value).to eq "666"
    end
  end

  describe "#register_history" do
    context "when issue_ids is nil" do
      context "when changeset is nil" do
        let(:history) { BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, nil, nil) }

        it_should_behave_like "history registration"

        it "creates history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, nil, nil)
          end.to change { BxHistory.count }.by(1)
        end
        it "doesn't create detail of history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, nil, nil)
          end.not_to change { BxHistoryDetail.count }
        end
        it "doesn't create relational issues" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, nil, nil)
          end.not_to change { BxHistoryIssue.count }
        end
      end
      context "when changeset is empty" do
        let(:history) { BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, [], nil) }

        it_should_behave_like "history registration"

        it "creates history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, [], nil)
          end.to change { BxHistory.count }.by(1)
        end
        it "doesn't create detail of history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, [], nil)
          end.not_to change { BxHistoryDetail.count }
        end
        it "doesn't create relational issues" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, [], nil)
          end.not_to change { BxHistoryIssue.count }
        end
      end
      context "when changeset is single set" do
        let(:history) { BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, { "foo" => ["111", "222"] }, nil) }

        it_should_behave_like "history registration"

        it "creates history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, { "foo" => ["111", "222"] }, nil)
          end.to change { BxHistory.count }.by(1)
        end

        it_should_behave_like "history detail single registration"

        it "creates detail of history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, { "foo" => ["111", "222"] }, nil)
          end.to change { BxHistoryDetail.count }.by(1)
        end
        it "doesn't create relational issues" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, { "foo" => ["111", "222"] }, nil)
          end.not_to change { BxHistoryIssue.count }
        end
      end

      context "when changeset is multi set" do
        let(:changesets) { { "foo" => ["111", "222"], "bar" => ["333", "444"], "baz" => ["555", "666"] } }
        let(:history) { BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, changesets, nil) }

        it_should_behave_like "history registration"

        it "creates history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, changesets, nil)
          end.to change { BxHistory.count }.by(1)
        end

        it_should_behave_like "history detail multi registration"

        it "creates details of history" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, changesets, nil)
          end.to change { BxHistoryDetail.count }.by(3)
        end
        it "doesn't create relational issues" do
          expect do
            BxHistoryService.new.register_history("test_target", "test_operation", "test_key", 3, changesets, nil)
          end.not_to change { BxHistoryIssue.count }
        end
      end
    end
  end
end
