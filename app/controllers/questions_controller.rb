class QuestionsController < ApplicationController
  def update
    @question = Question.find params[:id]
    @step = @question.step

    respond_to do |format|
      if params[:commit] == 'Save'
        if @question.update_attributes(params[:step]['questions_attributes']['0'])
          @min_score, @max_score = @step.score_sums
          @questions_count = @step.questions.count

          @question = Question.find params[:id]
          @valid = true
        else
          @valid = false
        end
      end

      format.js {}
    end
  end

  def destroy
    @question = Question.find params[:id]
    @step = @question.step

    respond_to do |format|
      if @question.destroy
        @step.reload
        @step_actions = @step.step_actions
        @min_score, @max_score = @step.score_sums
        @questions_count = @step.questions.count
      end

      format.js {}      
    end
  end
end
