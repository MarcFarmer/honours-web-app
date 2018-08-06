class InstructionsController < ApplicationController
  def update
    @instruction = Instruction.find params[:id]
    @step = @instruction.step

    respond_to do |format|
      if params[:commit] == 'Save'
        if @instruction.update_attributes(params[:step]['instructions_attributes']['0'])
          @instruction = Instruction.find params[:id]
          @valid = true
        else
          @valid = false
        end
      end

      format.js {}
    end
  end

  def destroy
    @instruction = Instruction.find params[:id]
    @step = @instruction.step

    respond_to do |format|
      if @instruction.destroy
        @step.reload
        @step_actions = @step.step_actions
      end

      format.js {}
    end
  end
end
