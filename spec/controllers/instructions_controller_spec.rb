require 'spec_helper'

describe InstructionsController do

  let (:instruction) { FactoryGirl.create(:instruction) }
  let (:step) { instruction.step }
  let (:pathway) { step.pathway }

  describe 'PUT #update' do
    it 'returns success' do
      put :update, "step"=>{"instructions_attributes"=>{"0"=>{"content"=>instruction.content, 
        "id"=>instruction.id}}}, "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, 
        "id"=>instruction.id, format: 'js'
      expect(response).to be_success
    end

    it 'loads the instruction to update into @instruction' do
      put :update, "step"=>{"instructions_attributes"=>{"0"=>{"content"=>instruction.content, 
        "id"=>instruction.id}}}, "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, 
        "id"=>instruction.id, format: 'js'
      expect(assigns(:instruction)).to eq(instruction)
    end

    it 'updates the content' do
      content = "Support ABCs"
      put :update, "step"=>{"instructions_attributes"=>{"0"=>{"content"=>content, 
        "id"=>instruction.id}}}, "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, 
        "id"=>instruction.id, format: 'js'
      expect(assigns(:instruction).content).to eq(content)
    end

    it 'does not update on cancel' do
      content = "Support ABCs"
      old_content = instruction.content
      put :update, "step"=>{"instructions_attributes"=>{"0"=>{"content"=>content, 
        "id"=>instruction.id}}}, "commit"=>"Cancel", "pathway_id"=>pathway.id, "step_id"=>step.id, 
        "id"=>instruction.id, format: 'js'
      expect(assigns(:instruction).content).to eq(old_content)
    end

    it 'assigns @valid to true for valid content' do
      content = "Support ABCs"
      put :update, "step"=>{"instructions_attributes"=>{"0"=>{"content"=>content, 
        "id"=>instruction.id}}}, "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, 
        "id"=>instruction.id, format: 'js'
      expect(assigns(:valid)).to eq(true)
    end

    it 'assigns @valid to false for invalid content' do
      content = ""  # blank content is invalid
      put :update, "step"=>{"instructions_attributes"=>{"0"=>{"content"=>content, 
        "id"=>instruction.id}}}, "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, 
        "id"=>instruction.id, format: 'js'
      expect(assigns(:valid)).to eq(false)
    end
  end

  describe 'DELETE #destroy' do
    it 'returns success' do
      delete :destroy, "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>instruction.id, format: 'js'
      expect(response).to be_success
    end

    it 'loads the instruction into @instruction' do
      delete :destroy, "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>instruction.id, format: 'js'
      expect(assigns(:instruction)).to eq(instruction)
    end

    it 'destroys the exit condition' do
      delete :destroy, "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>instruction.id, format: 'js'
      expect(step.instructions).to be_empty
    end
  end

end
