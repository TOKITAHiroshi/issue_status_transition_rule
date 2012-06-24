require_dependency 'issue'

module IssuePatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
    end
  end
  
  module InstanceMethods
    def hook_validate
      current = Issue.find_by_id(self.id)
      if(current != nil) 
        IssueStatusTransitionValidator.validate(current, self, errors)
      end
    end
  end
end

# Add module to Issue
Issue.send(:include, IssuePatch)
Issue.send(:validate, :hook_validate)
