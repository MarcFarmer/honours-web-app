class ExitConditionsController < ApplicationController
  def create
    @step = Step.find params[:step_id]

    # ExitCondition stores exit step id, but form asks user for exit step name
    exit_step_name = params['step']['exit_conditions_attributes']['0']['exit_step']

    # if the exit_step name given by the user already exists, use it in exit_condition
    pathway = @step.pathway
    existing_exit_step = Step.find_by_pathway_id_and_name pathway, exit_step_name

    if existing_exit_step == nil    # if givne exit_step name is not found, make a new step instance
      @exit_step = pathway.steps.build name: exit_step_name
    else
      @exit_step = existing_exit_step
    end

    # get risk values from nested model form fields
    min_risk = params['step']['exit_conditions_attributes']['0']['min_risk'].to_i
    max_risk = params['step']['exit_conditions_attributes']['0']['max_risk'].to_i
    @step.exit_conditions.new(step: @step, exit_step: @exit_step, min_risk: min_risk, max_risk: max_risk)

    respond_to do |format|
      if @exit_step.valid? && @step.valid?
        if @exit_step.save && @step.save
          @exit_conditions = @step.exit_conditions
        else
          @step.exit_conditions = @step.exit_conditions[0..-2] # remove exit condition to prevent it being rendered
          @exit_conditions = @step.exit_conditions
        end

        @exit_conditions_present = ExitCondition.find_all_by_step_id(@step.id).present?
        @valid = true
      else
        @step.exit_conditions = @step.exit_conditions[0..-2] # remove exit condition to prevent it being rendered
        @exit_conditions = @step.exit_conditions
        @exit_conditions_present = ExitCondition.find_all_by_step_id(@step.id).present?
        @valid = false
      end

      format.js {}
    end
  end

  def update
    @exit_condition = ExitCondition.find params[:id]
    @step = @exit_condition.step

    min_risk = params['step']['exit_conditions_attributes']['0']['min_risk'].to_i
    max_risk = params['step']['exit_conditions_attributes']['0']['max_risk'].to_i
    respond_to do |format|
      if params[:commit] == 'Save'
        if @exit_condition.update_attributes(min_risk: min_risk, max_risk: max_risk)
          @valid = true
        else
          @valid = false
        end
      end

      format.js {}
    end
  end

  def destroy
    @exit_condition = ExitCondition.find params[:id]
    @step = @exit_condition.step

    respond_to do |format|
      if @exit_condition.destroy
        @step.reload
        @exit_conditions = @step.exit_conditions
        @exit_conditions_present = @exit_conditions.present?
      else
        @exit_conditions_present = ExitCondition.find_all_by_step_id(@step.id).present?
      end

      format.js {}
    end
  end

  def edit_in_list
    @exit_condition = ExitCondition.find params[:exit_condition_id]
    @step = @exit_condition.step

    respond_to do |format|
      format.js {}
    end
  end
end
