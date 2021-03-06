require File.dirname(__FILE__) + '/../test_helper'

class IssueStatusTransitionRuleTest < ActiveSupport::TestCase
  self.fixture_path = File.dirname(__FILE__) + "/../fixtures/"
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  
  fixtures :issue_status_transition_rules, :issues

  # Replace this with your real tests.
  def test_truth
    assert true
  end

  def test_not_changed
    issue = Issue.find(1)

    p issue.methods

    issue.status_id = 2

    p issue.status_id

    p "issue.save"
    begin 
      if issue.save
        p issue
        assert true
        p issue
      end
    rescue Exception => e
      p e
    end
    p "issue.save end"
  end 

  def test_not_changed_fail
    issue = Issue.find(2)

    issue.status_id = 2
    issue.subject = "changed"

    unless issue.save
      assert true
    end
  end 





end
