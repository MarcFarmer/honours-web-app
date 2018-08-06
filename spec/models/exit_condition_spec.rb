require 'spec_helper'

describe ExitCondition do
  describe "factory" do
    it "has a valid factory" do
      expect(FactoryGirl.build(:exit_condition)).to be_valid
    end
  end

  describe "relations with steps" do
    it "should require a step" do
      expect(FactoryGirl.build(:exit_condition, step: nil)).to_not be_valid
    end

    it "should require an exit" do
      expect(FactoryGirl.build(:exit_condition, step: nil)).to_not be_valid
    end
  end

  describe "editing the risk score" do
    it "should require min risk >= 0" do
      expect(FactoryGirl.build(:exit_condition, min_risk: -1, max_risk: 1)).to_not be_valid
    end

    it "should require max risk >= 0" do
      expect(FactoryGirl.build(:exit_condition, min_risk: 0, max_risk: -1)).to_not be_valid
    end

    it "should require min_risk <= max_risk" do
      expect(FactoryGirl.build(:exit_condition, min_risk: 2, max_risk: 1 )).to_not be_valid
    end
  end

  describe "overlapping ranges for a given step" do
    let (:step) { FactoryGirl.create(:step) }
    let (:min_risk) { 2 }
    let (:max_risk) { 5 }
    let! (:exit_condition) { FactoryGirl.create(:exit_condition, step: step, min_risk: min_risk, max_risk: max_risk) }

    it "does not allow duplicate ranges" do
      new_exit_condition = FactoryGirl.build(:exit_condition, step: step, min_risk: min_risk, max_risk: max_risk)
      expect(new_exit_condition).to_not be_valid
    end

    it "does not allow overlapping ranges" do
      new_exit_condition = FactoryGirl.build(:exit_condition, step: step, min_risk: min_risk-1, max_risk: max_risk-1)
      expect(new_exit_condition).to_not be_valid
    end

    it "does not allow subset of existing range" do
      new_exit_condition = FactoryGirl.build(:exit_condition, step: step, min_risk: min_risk+1, max_risk: max_risk-1)
      expect(new_exit_condition).to_not be_valid
    end

    it "does not allow superset of existing range" do
      new_exit_condition = FactoryGirl.build(:exit_condition, step: step, min_risk: min_risk-1, max_risk: max_risk+1)
      expect(new_exit_condition).to_not be_valid
    end

    it "does not allow max_risk == existing min_risk" do
      new_exit_condition = FactoryGirl.build(:exit_condition, step: step, min_risk: min_risk-1, max_risk: min_risk)
      expect(new_exit_condition).to_not be_valid
    end

    it "does not allow min_risk == existing max_risk" do
      new_exit_condition = FactoryGirl.build(:exit_condition, step: step, min_risk: max_risk, max_risk: max_risk+1)
      expect(new_exit_condition).to_not be_valid
    end

    it "allows ranges that do not overlap" do
      new_exit_condition = FactoryGirl.build(:exit_condition, step: step, min_risk: max_risk+1, max_risk: max_risk+2)
      expect(new_exit_condition).to be_valid
    end

    it "allows updating the scores to a range that overlaps with the current range" do
      expect{ exit_condition.update_attributes(min_risk: min_risk+1, max_risk: max_risk) }
        .to change{exit_condition.min_risk}.from(min_risk).to(min_risk+1)
    end
  end

  describe "order" do
    let (:step) { FactoryGirl.create(:step) }
    let (:ec1) { FactoryGirl.create(:exit_condition, step: step, min_risk: 1, max_risk: 1) }
    let (:ec2) { FactoryGirl.create(:exit_condition, step: step, min_risk: 0, max_risk: 0) }
    let (:ec3) { FactoryGirl.create(:exit_condition, step: step, min_risk: 2, max_risk: 2) }

    it "returns exit conditions for a given step in order of min_risk" do
      expect(step.exit_conditions).to eq ([ec2, ec1, ec3])
    end
  end
end
