require 'spec_helper'

describe Answer do
  describe "factory" do
    it "is valid" do
      expect(FactoryGirl.create(:answer)).to be_valid
    end
  end
end
