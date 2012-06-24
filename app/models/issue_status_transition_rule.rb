class IssueStatusTransitionRule < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes

  validates_presence_of :name

  safe_attributes 'name',
    'tracker',
    'current_status',
    'next_status',
    'condition'

end
