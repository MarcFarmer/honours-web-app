require 'spec_helper'

describe StepsController do
  let(:step) { FactoryGirl.create(:step) }

  describe 'GET #edit' do
    let (:question) { FactoryGirl.create(:question, step: step) }
    let (:instruction) { FactoryGirl.create(:instruction, step: step) }

    it 'loads the step into @step' do
      get :edit, {pathway_id: step.pathway.id, id: step.id}
      expect(assigns(:step)).to eq(step)
    end

    it "returns http success" do
      get :edit, {pathway_id: step.pathway.id, id: step.id}
      expect(response).to be_success
    end

    it 'creates a new exit_condition for the parent step' do
      get :edit, {pathway_id: step.pathway.id, id: step.id}
      expect(assigns(:step).exit_conditions).not_to be_empty
    end

    it 'loads questions and instructions into @step_actions' do
      question = FactoryGirl.create(:question, step: step)
      instruction = FactoryGirl.create(:instruction, step: step)

      get :edit, {pathway_id: step.pathway.id, id: step.id}
      expect(assigns(:step_actions)).to eq([question, instruction])
    end

    context '@exit_conditions_present' do
      it 'is true with exit condition' do
        FactoryGirl.create(:exit_condition, step: step)
        get :edit, {pathway_id: step.pathway.id, id: step.id}
        expect(assigns(:exit_conditions_present)).to eq(true)
      end

      it 'is false with no exit conditions' do
        get :edit, {pathway_id: step.pathway.id, id: step.id}
        expect(assigns(:exit_conditions_present)).to eq(false)
      end
    end
  end

  describe 'GET #edit_instruction_in_list' do
    let (:instruction) { FactoryGirl.create(:instruction, step: step) }

    it 'returns success' do
      xhr :get, :edit_instruction_in_list, instruction_id: instruction.id
      expect(response).to be_success
    end

    it 'loads the current step into @step' do
      xhr :get, :edit_instruction_in_list, instruction_id: instruction.id
      expect(assigns(:step)).to eq(instruction.step)
    end

    it 'loads the instruction to edit into @instruction' do
      xhr :get, :edit_instruction_in_list, instruction_id: instruction.id
      expect(assigns(:step)).to eq(instruction.step)
    end
  end

  describe 'GET #edit_question_in_list' do
    let (:question) { FactoryGirl.create(:question, step: step) }

    it 'returns success' do
      xhr :get, :edit_question_in_list, question_id: question.id
      expect(response).to be_success
    end

    it 'loads the current step into @step' do
      xhr :get, :edit_question_in_list, question_id: question.id
      expect(assigns(:step)).to eq(question.step)
    end

    it 'loads the question to edit into @question' do
      xhr :get, :edit_question_in_list, question_id: question.id
      expect(assigns(:question)).to eq(question)
    end
  end

  describe 'PUT #modal_edit' do
    it 'returns success' do
      put :modal_edit, pathway_id: step.pathway.id, id: step.id, pathway: 
      { steps_attributes: { '0' => { name: 'A new name', id: step.id} } }, format: 'js'
      expect(response).to be_success
    end

    it 'loads the current step into @step' do
      put :modal_edit, pathway_id: step.pathway.id, id: step.id, pathway: 
      { steps_attributes: { '0' => { name: 'A new name', id: step.id} } }, format: 'js'
      expect(assigns(:step)).to eq(step)
    end

    it 'loads the current step pathway into @pathway' do
      put :modal_edit, pathway_id: step.pathway.id, id: step.id, pathway: 
      { steps_attributes: { '0' => { name: 'A new name', id: step.id} } }, format: 'js'
      expect(assigns(:pathway)).to eq(step.pathway)
    end

    context 'step name is valid' do
      it 'updates step name' do
        name = 'Is patient unstable?'
        put :modal_edit, pathway_id: step.pathway.id, id: step.id, pathway: 
        { steps_attributes: { '0' => { name: name, id: step.id} } }, format: 'js'
        expect(step.reload.name).to eq(name)
      end
    end

    context 'step name is invalid' do
      it 'does not update step name' do
        initial_name = step.name
        put :modal_edit, pathway_id: step.pathway.id, id: step.id, pathway: 
        { steps_attributes: { '0' => { name: '', id: step.id} } }, format: 'js'
        expect(step.reload.name).to eq(initial_name)
      end
    end
  end

  describe 'PUT #move_up_in_list' do
    let (:question) { FactoryGirl.create(:question, step: step) }
    let (:instruction) { FactoryGirl.create(:instruction, step: step) }

    it 'returns success' do
      put :move_up_in_list, step_action_id: instruction.id, format: 'js'
      expect(response).to be_success
    end

    it 'swaps position' do
      question_position = question.position
      instruction_position = instruction.position

      put :move_up_in_list, step_action_id: instruction.id, format: 'js'
      question.reload
      instruction.reload

      expect(question.position).to eq(instruction_position)
      expect(instruction.position).to eq(question_position)
    end

    it 'does not change position of the first step action' do
      question_id = question.id

      put :move_up_in_list, step_action_id: question.id, format: 'js'
      question.reload

      expect(question.id).to eq(question_id)
    end
  end

  describe 'PUT #move_down_in_list' do
    let (:question) { FactoryGirl.create(:question, step: step) }
    let (:instruction) { FactoryGirl.create(:instruction, step: step) }

    it 'returns success' do
      put :move_down_in_list, step_action_id: question.id, format: 'js'
      expect(response).to be_success
    end

    it 'swaps position' do
      question_position = question.position
      instruction_position = instruction.position

      put :move_down_in_list, step_action_id: question.id, format: 'js'
      question.reload
      instruction.reload

      expect(question.position).to eq(instruction_position)
      expect(instruction.position).to eq(question_position)
    end

    it 'does not change position of the last step action' do
      instruction_id = instruction.id

      put :move_down_in_list, step_action_id: instruction.id, format: 'js'
      instruction.reload

      expect(instruction.id).to eq(instruction_id)
    end
  end

  describe 'GET #preview' do
    let (:step_to_preview) { FactoryGirl.create(:step, pathway: step.pathway) }

    it 'returns success' do
      get :preview, { pathway_id: step.pathway.id, id: step_to_preview.id, return_step_id: step.id }
      expect(response).to be_success
    end

    it 'loads step for preview into @step' do
      get :preview, { pathway_id: step.pathway.id, id: step_to_preview.id, return_step_id: step.id }
      expect(assigns(:step)).to eq(step_to_preview)
    end

    it 'loads return step for exiting preview into @return_step' do
      get :preview, { pathway_id: step.pathway.id, id: step_to_preview.id, return_step_id: step.id }
      expect(assigns(:return_step)).to eq(step)
    end
  end

  describe '#PUT update' do
    it 'creates a new instruction' do
      instuction_count = step.instructions.count
      put :update, { "step"=>{"instructions_attributes"=>{"0"=>{"content"=>"Support ABCs"}}},
       "commit"=>"Submit instruction", "pathway_id"=>step.pathway.id, "id"=>step.id }
      expect(step.instructions.count).to eq(instuction_count + 1)
    end

    it 'creates a new question' do
      question_count = step.questions.count
      put :update, { "step"=>
        {"questions_attributes"=>{"0"=>{"content"=>"Heart failure?", "answers_attributes"=>{
          "0"=>{"content"=>"Yes", "score"=>"1", "_destroy"=>"false"}, 
          "1"=>{"content"=>"No", "score"=>"0", "_destroy"=>"false"}}}}}, 
          "commit"=>"Submit question and answers", "pathway_id"=>step.pathway.id, "id"=>step.id }
      expect(step.questions.count).to eq(question_count + 1)
    end
  end

  describe 'POST #preview_submit' do
    let (:pathway) { FactoryGirl.create(:pathway, name: 'Tachycardia') }
    let! (:step1) { FactoryGirl.create(:step, pathway: pathway) }
    let! (:step2) { FactoryGirl.create(:step, pathway: pathway) }

    it 'loads the pathway being previewed into @pathway' do
      post :preview_submit, { "next_step_id"=>step2.id, "pathway_id"=>pathway.id, 
        "id"=>pathway.id, "return_step_id"=>step1.id }
      expect(assigns(:pathway)).to eq(step1.pathway)
    end

    it 'loads the next step to preview into @step' do
      post :preview_submit, { "next_step_id"=>step2.id, "pathway_id"=>pathway.id, 
        "id"=>pathway.id, "return_step_id"=>step1.id }
      expect(assigns(:step)).to eq(step2)
    end
  end
end
