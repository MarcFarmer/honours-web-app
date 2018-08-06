require 'spec_helper'

describe StepAction do
  describe "step actions" do
    let(:step) { FactoryGirl.create(:step) }

    it "should find all owned step actions" do
      q1 = FactoryGirl.create(:question, step: step)
      i1 = FactoryGirl.create(:instruction, step: step)
      i2 = FactoryGirl.create(:instruction, step: step)
      step_actions_array = [q1, i1, i2]

      expect(StepAction.find_all_by_step_id step).to eq(step_actions_array)
    end

    it "should return results in order of position" do
      q1 = FactoryGirl.create(:question, step: step)
      i1 = FactoryGirl.create(:instruction, step: step)
      i2 = FactoryGirl.create(:instruction, step: step)

      i1.swap_position(i2)
      i1.save
      i2.save

      step_actions_array = [q1, i2, i1]

      expect(StepAction.find_all_by_step_id step).to eq(step_actions_array)
    end
  end
end
