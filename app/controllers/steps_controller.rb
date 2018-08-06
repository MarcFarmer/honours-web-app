class StepsController < ApplicationController
  def edit
    @pathway = Pathway.find(params[:pathway_id])
    @step = Step.find(params[:id])

    @min_score, @max_score = @step.score_sums
    @questions_count = @step.questions.count

    @question = @step.questions.build
    @question.answers.build(score: 1)
    @question.answers.build(score: 1)

    @step.instructions.build
    @exit_condition = @step.exit_conditions.build

    @step_actions = @step.step_actions

    @first_step = @pathway.steps.first
    if @step == @first_step
      @parent_steps = nil
    else
      @parent_steps = ExitCondition.find_all_by_exit_step_id(@step).map { |ec| ec.step }
    end

    @exit_conditions_present = ExitCondition.find_all_by_step_id(@step.id).present?
  end

  def update
    @pathway = Pathway.find(params[:pathway_id])
    @step = Step.find(params[:id])

    @min_score, @max_score = @step.score_sums
    @questions_count = @step.questions.count

    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to edit_pathway_step_path(@pathway, @step) }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def edit_instruction_in_list
    @instruction = Instruction.find params[:instruction_id]
    @step = @instruction.step

    respond_to do |format|
      format.js {}
    end
  end

  def edit_question_in_list
    @question = Question.find params[:question_id]
    @step = @question.step

    respond_to do |format|
      format.js {}
    end
  end

  def modal_edit
    @step = Step.find(params[:id])
    @pathway = @step.pathway

    respond_to do |format|
      if @pathway.update_attributes(params[:pathway])
        @step.reload # get updated step name to render
        @valid = true
      else
        @valid = false
      end

      format.js {}
    end
  end

  def move_up_in_list
    @step_action = StepAction.find(params[:step_action_id])
    @step = @step_action.step
    @step_actions = @step.step_actions

    # find the first step action before the one to be moved up
    # if there are no step actions before, previous_step_action == current_step
    previous_step_action = StepAction.where("step_id = ?",@step.id).where("position < ?", @step_action.position).last || @step_action
    @step_action.swap_position(previous_step_action)

    respond_to do |format|
      if @step_action.save && previous_step_action.save
        @valid = true
      else
        @valid = false
      end

      format.js {}
    end
  end

  def move_down_in_list
    @step_action = StepAction.find(params[:step_action_id])
    @step = @step_action.step
    @step_actions = @step.step_actions

    # find the first step action before the one to be moved up
    # if there are no step actions before, previous_step_action == current_step
    next_step_action = StepAction.where("step_id = ?",@step.id).where("position > ?", @step_action.position).first || @step_action
    @step_action.swap_position(next_step_action)

    respond_to do |format|
      if @step_action.save && next_step_action.save
        @valid = true
      else
        @valid = false
      end

      format.js {}
    end
  end

  def preview
    @pathway = Pathway.find(params[:pathway_id])
    @step = Step.find(params[:id])
    @return_step = Step.find(params[:return_step_id])
    @min_score, @max_score = @step.score_sums
  end

  def preview_submit
    @pathway = Pathway.find(params[:pathway_id])
    @step = Step.find(params[:next_step_id])
    @return_step = Step.find(params[:return_step_id])
    @min_score, @max_score = @step.score_sums

    render 'preview'
  end
end
