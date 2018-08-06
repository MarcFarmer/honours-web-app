require 'spec_helper'

describe Instruction do
  describe "factory" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:instruction)).to be_valid
    end
  end

  describe "editing the content" do
    it "should require a content" do
      expect(FactoryGirl.build(:instruction, content: '')).to_not be_valid
    end

    it "should have content Give patient water" do
      instruction = FactoryGirl.create(:instruction, content: "Give patient water")
      expect(instruction.content).to eq("Give patient water")
    end
  end

  describe "belonging to step" do
    it "should have a reference to a step" do
      step = Step.create name: 'Stage 1'
      instruction = step.instructions.create content: "Give patient water"
      expect(instruction.step).to eq(step)
    end
  end

  describe "has position" do
    let(:step1) { FactoryGirl.create(:step) }
    let(:instruction1) { FactoryGirl.create(:instruction, step: step1) }
    let(:instruction2) { FactoryGirl.create(:instruction, step: step1) }
    let(:question1) { FactoryGirl.create(:question, step: step1) }

    context "#position" do
      it "should set position equal to id when created" do
        expect(instruction1.position).to eq(instruction1.id)
      end
    end

    context "#swap_position" do
      it "should swap position value with another instruction" do
        old_position1 = instruction1.position
        old_position2 = instruction2.position

        instruction1.swap_position(instruction2)

        expect(instruction1.position).to eq(old_position2)
        expect(instruction2.position).to eq(old_position1)
      end

      it "should swap position value with a question" do
        old_position_instruction = instruction1.position
        old_position_question = question1.position

        instruction1.swap_position(question1)

        expect(instruction1.position).to eq(old_position_question)
        expect(question1.position).to eq(old_position_instruction)
      end
    end
  end
end
