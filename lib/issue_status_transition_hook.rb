
class IssueStatusTransitionHook < Redmine::Hook::Listener
  def controller_issues_edit_before_save(context)
    issue = context[:issue]
    def issue.editor_id ; @editor_id; end
    def issue.editor_id=(val) ; @editor_id=val ; end
    issue.editor_id=context[:journal].user_id
  end
end
