require 'issue_patch'
require 'issue_status_transition_validator'
require 'issue_status_transition_hook'

Redmine::Plugin.register :issue_status_transition_rule do
  name 'Issue Status Transition Rule plugin'
  author 'TOKITA Hiroshi'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  menu :admin_menu, :issue_status_transition_rules, 
    { :controller => 'issue_status_transition_rules', :action => 'index' },
    :caption => "rules", :last => true
end
