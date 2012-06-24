class IssueStatusTransitionValidator

  class IssueStatusTransitionException < Exception
    def initialize(attr, msg)
      @attr = attr
      @msg = msg
    end
    attr_accessor :attr, :msg
  end

  class IssueStatusRuleRunner
    attr_reader :errors

    def initialize
      @errors = []
    end

    def add_error(attribute, message=nil, options={})
      @errors += [[attribute, message]]
    end

    def allow_for_role(role_name)
      member = Member.all(:include=>:roles, :conditions=>{:user_id=>@update.editor_id, :project_id=>@update.project_id})
      roles = member[0].roles.select {|r| r.name==role_name }

      unless roles.size == 0
        add_error([:base, "Not enough permissions."])
      end
    end

    def not_changed(sym)
      unless @current.public_send(sym) == @update.public_send(sym)
        add_error(sym, "is not allow change by rule.")
      end
    end

    def changed(sym)
      unless @current.public_send(sym) != @update.public_send(sym)
        add_error(sym, "is must change by rule.")
      end
    end

    def equals(sym, value)
      unless @update.public_send(sym) == value
        add_error(sym, "is allow only #{value}.")
      end
    end

    def not_equals(sym)
      unless @current.public_send(sym) != @update.public_send(sym)
        add_error(sym, "is not allowd #{value}.")
      end
    end

    def greater_than(sym, value)
      unless @update.public_send(sym) > value
        add_error(sym, "is not greater than #{value}.")
      end
    end

    def greater_than_or_equals(sym, value)
      unless @update.public_send(sym) >= value
        add_error(sym, "is not greater than or equals #{value}.")
      end
    end

    def less_than(sym, value)
      unless @update.public_send(sym) < value
        add_error(sym, "is not less than #{value}.")
      end
    end

    def less_than_or_equals(sym, value)
      unless @update.public_send(sym) <= value
        add_error(sym, "is not less than or equals #{value}.")
      end
    end

    def newer_than(sym, value)
      unless Time.parse(@update.public_send(sym).to_s) > Time.parse(value.to_s)
        add_error(sym, "is not newer than #{value.to_s}.")
      end
    end

    def older_than(sym, value)
      unless Time.parse(@update.public_send(sym).to_s) < Time.parse(value.to_s)
        add_error(sym, "is not older than #{value.to_s}.")
      end
    end

    def eval_code(code)
      eval(code)
    end

  end
  
  def self.validate(current, update, errors)
    rules = IssueStatusTransitionRule.where(:tracker=>update.tracker_id,
                                            :current_status=>current.status_id,
                                            :next_status=>update.status_id)

    rules.each do |rule|
      begin
        runner= IssueStatusRuleRunner.new
        runner.instance_variable_set(:@current, current.clone)
        runner.instance_variable_set(:@update, update.clone)

        begin
          runner.eval_code(rule.condition)
          runner.errors.each do |errinfo|
            errors.add(errinfo[0], errinfo[1])
          end
        rescue IssueStatusTransitionException => iste
          errors.add iste.attr, iste.msg
        end
      rescue => e
        errors.add e.to_s
      end
    end 
  end

  def safe(level)
    result = nil
    Thread.start {
      $SAFE = level
      result = yield
    }.join
    result
  end

end
