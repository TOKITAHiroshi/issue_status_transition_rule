class IssueStatusTransitionRulesController < ApplicationController
  unloadable

  helper_method :settings

  before_filter :require_istr


  helper :custom_fields
  include CustomFieldsHelper

  def require_istr
    @trackers = Tracker.all
    @issue_statuses = IssueStatus.all(:order => 'position')
  end

  def index
    @issue_status_transition_rules = IssueStatusTransitionRule.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end


  def new
    @issue_status_transition_rule = IssueStatusTransitionRule.new
  end

  def create
    @issue_status_transition_rule = IssueStatusTransitionRule.new
    @issue_status_transition_rule.safe_attributes = params[:issue_status_transition_rule]

    if @issue_status_transition_rule.save
      redirect_to :action =>'index'
    else
      respond_to do |format|
        format.html { render :action => 'new' }
        format.api  { render_validation_errors(@issue) }
      end
    end
  end

  def destroy
    @issue_status_transition_rule = IssueStatusTransitionRule.find(params[:id])
    @issue_status_transition_rule.destroy

    redirect_to :action =>'index'
  end

  def edit
    @issue_status_transition_rule = IssueStatusTransitionRule.find(params[:id])
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def update
    @issue_status_transition_rule = IssueStatusTransitionRule.find(params[:id])
    @issue_status_transition_rule.safe_attributes = params[:issue_status_transition_rule]

    if @issue_status_transition_rule.save
      redirect_to :action =>'index'
    else
      respond_to do |format|
        format.html { render :action => 'edit' }
      end
    end
  end

  def show
    @issue_status_transition_rule = IssueStatusTransitionRule.find(params[:id])
  end

  def help
    render :layout=>false
  end


end
