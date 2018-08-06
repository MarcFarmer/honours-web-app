require 'spec_helper'

describe ExitConditionsController do

  describe 'POST #create' do
    let(:step1) { FactoryGirl.create(:step) }
    let(:step2) { FactoryGirl.create(:step) }

    it 'loads the current step into @step' do
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"ThisIsMyExitStep", "min_risk"=>"1", "max_risk"=>"2"}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(assigns(:step)).to eq(step1)
    end

    it "does not redirect with valid attributes" do
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"ThisIsMyExitStep", "min_risk"=>"1", "max_risk"=>"2"}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(response).not_to be_redirect
    end

    it "does not redirect with missing attributes" do
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"", "min_risk"=>"1", "max_risk"=>"2"}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(response).not_to be_redirect
    end

    it "creates a new step when the exit step does not exist" do
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"#{step1.name}#{step2.name}", "min_risk"=>"1", "max_risk"=>"2"}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(assigns(:step).exit_conditions.last.exit_step.id).to eq(step2.id + 1)
    end

    it "does not create a new step when the exit step exists" do
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"#{step2.name}", "min_risk"=>"1", "max_risk"=>"2"}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(assigns(:step).pathway.steps.count).to eq(2)
    end

    it "saves min risk" do
      min_risk = 5
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"StepName", "min_risk"=>min_risk, "max_risk"=>"10"}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(assigns(:step).exit_conditions.last.min_risk).to eq(min_risk)
    end

    it "saves max risk" do
      max_risk = 10
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"StepName", "min_risk"=>"1", "max_risk"=>max_risk}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(assigns(:step).exit_conditions.last.max_risk).to eq(max_risk)
    end

    it "does not create an exit condition with invalid attributes" do
      invalid_min_risk = -1
      post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
        "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
          "exit_step"=>"#{step2.name}", "min_risk"=>invalid_min_risk, "max_risk"=>"2"}}}, 
          "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
      expect(assigns(:step).exit_conditions).to eq([])
    end

    context '@exit_conditions_present' do
      it 'is true with exit condition' do
        post :create, { pathway_id: step1.pathway.id, step_id: step1.id, 
          "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step1.id, 
            "exit_step"=>"ThisIsMyExitStep", "min_risk"=>"1", "max_risk"=>"2"}}}, 
            "commit"=>"Add step", "pathway_id"=>"1", "step_id"=>step1.id}
        expect(assigns(:exit_conditions_present)).to eq(true)
      end
    end
  end

  describe 'GET #edit_in_list' do
    let (:exit_condition) { FactoryGirl.create(:exit_condition) }

    it 'returns success' do
      xhr :get, :edit_in_list, exit_condition_id: exit_condition.id
      expect(response).to be_success
    end

    it 'loads the current step into @step' do
      xhr :get, :edit_in_list, exit_condition_id: exit_condition.id
      expect(assigns(:step)).to eq(exit_condition.step)
    end
  end

  describe 'PUT #update' do
    let (:step) { FactoryGirl.create(:step) }
    let (:pathway) { step.pathway }
    let (:exit_condition) { FactoryGirl.create(:exit_condition, step: step) }

    it 'returns success' do
      put :update, "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step.id, 
        "min_risk"=>"121", "max_risk"=>"321", "id"=>exit_condition.id}}}, "commit"=>"Save", 
        "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(response).to be_success
    end

    it 'loads the exit condition to update into @exit_condition' do
      put :update, "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step.id, 
        "min_risk"=>"121", "max_risk"=>"321", "id"=>exit_condition.id}}}, "commit"=>"Save", 
        "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(assigns(:exit_condition)).to eq(exit_condition)
    end

    it 'updates the risk score' do
      min_risk = 321
      max_risk = 999
      put :update, "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step.id, 
        "min_risk"=>min_risk, "max_risk"=>max_risk, "id"=>exit_condition.id}}}, "commit"=>"Save", 
        "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(assigns(:exit_condition).min_risk).to eq(min_risk)
      expect(assigns(:exit_condition).max_risk).to eq(max_risk)
    end

    it 'does not update on cancel' do
      min_risk = 321
      max_risk = 999
      old_min_risk = exit_condition.min_risk
      old_max_risk = exit_condition.max_risk
      put :update, "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step.id, 
        "min_risk"=>min_risk, "max_risk"=>max_risk, "id"=>exit_condition.id}}}, "commit"=>"Cancel", 
        "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(assigns(:exit_condition).min_risk).to eq(old_min_risk)
      expect(assigns(:exit_condition).max_risk).to eq(old_max_risk)
    end

    it 'assigns @valid to true for valid scores' do
      min_risk = 1
      max_risk = 2
      put :update, "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step.id, 
        "min_risk"=>min_risk, "max_risk"=>max_risk, "id"=>exit_condition.id}}}, "commit"=>"Save", 
        "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(assigns(:valid)).to eq(true)
    end

    it 'assigns @valid to false for invalid scores' do
      min_risk = 2
      max_risk = 1
      put :update, "step"=>{"exit_conditions_attributes"=>{"0"=>{"step"=>step.id, 
        "min_risk"=>min_risk, "max_risk"=>max_risk, "id"=>exit_condition.id}}}, "commit"=>"Save", 
        "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(assigns(:valid)).to eq(false)
    end

  end

  describe 'DELETE #destroy' do
    let (:step) { FactoryGirl.create(:step) }
    let (:pathway) { step.pathway }
    let (:exit_condition) { FactoryGirl.create(:exit_condition, step: step, min_risk: 10, max_risk: 20) }

    it 'returns success' do
      delete :destroy, { "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js' }
      expect(response).to be_success
    end

    it 'loads the exit condition into @exit_condition' do
      delete :destroy, "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(assigns(:exit_condition)).to eq(exit_condition)
    end

    it 'destroys the exit condition' do
      delete :destroy, "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js'
      expect(step.exit_conditions).to be_empty
    end

    context '@exit_conditions_present' do
      it 'is true with exit condition' do
        FactoryGirl.create(:exit_condition, step: step, min_risk: 30, max_risk: 40) # create another exit condition
        delete :destroy, { "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js' }
        expect(assigns(:exit_conditions_present)).to eq(true)
      end

      it 'is false with no exit conditions' do
        delete :destroy, { "pathway_id"=>pathway.id, "step_id"=>step.id, "id"=>exit_condition.id, format: 'js' }
        expect(assigns(:exit_conditions_present)).to eq(false)
      end
    end
  end

end
