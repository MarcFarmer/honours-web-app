require 'spec_helper'

describe QuestionsController do

  let (:question) { FactoryGirl.create(:question) }
  let (:step) { question.step }
  let (:pathway) { step.pathway }

  describe 'PUT #update' do
    it 'returns success' do
      put :update, "step"=>{"questions_attributes"=>{
        "0"=>{"content"=>question.content, "id"=>question.id}}},
         "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(response).to be_success
    end

    it 'loads the question to update into @question' do
      put :update, "step"=>{"questions_attributes"=>{
        "0"=>{"content"=>question.content, "id"=>question.id}}},
         "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(assigns(:question)).to eq(question)
    end

    it 'updates the content' do
      content = "Is QRS narrow?"
      put :update, "step"=>{"questions_attributes"=>{
        "0"=>{"content"=>content, "id"=>question.id}}}, 
        "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(assigns(:question).content).to eq(content)
    end

    it 'does not update on cancel' do
      content = "Is QRS narrow?"
      old_content = question.content
      put :update, "step"=>{"questions_attributes"=>{
        "0"=>{"content"=>content, "id"=>question.id}}}, 
        "commit"=>"Cancel", "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(assigns(:question).content).to eq(old_content)
    end

    it 'assigns @valid to true for valid content' do
      content = "Is QRS narrow?"
      put :update, "step"=>{"questions_attributes"=>{
        "0"=>{"content"=>content, "id"=>question.id}}}, 
        "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(assigns(:valid)).to eq(true)
    end

    it 'assigns @valid to false for invalid content' do
      content = ""  # blank content is invalid
      put :update, "step"=>{"questions_attributes"=>{
        "0"=>{"content"=>content, "id"=>question.id}}}, 
        "commit"=>"Save", "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(assigns(:valid)).to eq(false)
    end
  end

  describe 'DELETE #destroy' do
    it 'returns success' do
      delete :destroy, { "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js' }
      expect(response).to be_success
    end

    it 'loads the question into @question' do
      delete :destroy, "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(assigns(:question)).to eq(question)
    end

    it 'destroys the exit condition' do
      delete :destroy, "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>question.id, format: 'js'
      expect(step.questions).to be_empty
    end
  end

end
