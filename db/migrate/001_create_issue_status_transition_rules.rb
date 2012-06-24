class CreateIssueStatusTransitionRules < ActiveRecord::Migration
  def change
    create_table :issue_status_transition_rules do |t|

      t.string :name

      t.integer :tracker

      t.integer :current_status

      t.integer :next_status

      t.string :condition


    end

  end
end
