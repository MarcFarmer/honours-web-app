require 'spec_helper'

describe Step do
  describe "editing the name" do
    let (:step) { FactoryGirl.create(:step, name: 'Is patient stable?') }

    it "should have name Is patient stable?" do
      expect(step.name).to eq('Is patient stable?')
    end

    it "requires a name to be valid" do
      step.name = nil
      expect(step).to_not be_valid
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:step)).to be_valid
    end
  end

  describe "#exit_conditions" do
    let(:step1) { FactoryGirl.create(:step) }
    let(:step2) { FactoryGirl.create(:step) }
    let(:step3) { FactoryGirl.create(:step) }
    let(:step4) { FactoryGirl.create(:step) }

    it "should add multiple exit_conditions to a step" do
      ec1 = step1.exit_conditions.create(step: step1, exit_step: step2, min_risk: 1, max_risk: 4)
      ec2 = step1.exit_conditions.create(step: step1, exit_step: step3, min_risk: 0, max_risk: 0)
      ec3 = step1.exit_conditions.create(step: step1, exit_step: step4, min_risk: 5, max_risk: 10)
      ec_array = [ec1, ec2, ec3]

      expect(step1.exit_conditions).to match_array(ec_array)
    end

    it "should not give ownership of exit_condition to after step" do
      ec1 = step1.exit_conditions.create(step: step1, exit_step: step2, min_risk: 1, max_risk: 4)

      expect(step2.exit_conditions).to be_empty
    end
  end

  describe "#step_actions" do
    let(:step) { FactoryGirl.create(:step) }
    let(:question1) { FactoryGirl.create(:question, step: step) }
    let(:instruction1) { FactoryGirl.create(:instruction, step: step) }
    let(:question2) { FactoryGirl.create(:question, step: step) }
    let(:instruction2) { FactoryGirl.create(:instruction, step: step) }

    it "returns all questions and instructions" do
      step_actions_array = [question1, instruction1, question2, instruction2]

      expect(step.step_actions).to eq(step_actions_array)
    end
  end

  describe "#score_sum" do
    let(:step) { FactoryGirl.create(:step) }
    let(:question1) { FactoryGirl.create(:question, step: step) }
    let!(:answer1a) { FactoryGirl.create(:answer, question: question1, score: 0) }
    let!(:answer1b) { FactoryGirl.create(:answer, question: question1, score: 1) }
    let(:question2) { FactoryGirl.create(:question, step: step) }
    let!(:answer2a) { FactoryGirl.create(:answer, question: question2, score: 2) }
    let!(:answer2b) { FactoryGirl.create(:answer, question: question2, score: 3) }

    it "returns two values" do
      min_score, max_score = step.score_sums
      expect(min_score).to_not be_nil
      expect(max_score).to_not be_nil
    end

    it "gives sum of min answer scores for each question as first return value" do
      min_score, max_score = step.score_sums
      expect(min_score).to eq(2)
    end

    it "gives sum of max answer scores for each question as second return value" do
      min_score, max_score = step.score_sums
      expect(max_score).to eq(4)
    end
  end
end
