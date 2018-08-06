require 'spec_helper'

describe Question do
  describe "factory" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:question)).to be_valid
    end
  end

  describe "has position" do
    let(:step1) { FactoryGirl.create(:step) }
    let(:instruction1) { FactoryGirl.create(:instruction, step: step1) }
    let(:question1) { FactoryGirl.create(:question, step: step1) }
    let(:question2) { FactoryGirl.create(:question, step: step1) }

    context "#position" do
      it "should set position equal to id when created" do
        expect(question1.position).to eq(question1.id)
      end
    end

    context "#swap_position" do
      it "should swap position value with another question" do
        old_position1 = question1.position
        old_position2 = question2.position

        question1.swap_position(question2)

        expect(question1.position).to eq(old_position2)
        expect(question2.position).to eq(old_position1)
      end

      it "should swap position value with an instruction" do
        old_position_question = question1.position
        old_position_instruction = instruction1.position

        question1.swap_position(instruction1)

        expect(question1.position).to eq(old_position_instruction)
        expect(instruction1.position).to eq(old_position_question)
      end
    end
  end
end
