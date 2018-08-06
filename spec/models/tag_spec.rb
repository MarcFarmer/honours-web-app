require 'spec_helper'

describe Tag do
  describe "factory" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:tag)).to be_valid
    end
  end

  describe "editing the name" do
    it "requires a name" do
      expect(FactoryGirl.build(:tag, name: '')).to_not be_valid
    end

    it "can set name = 'Rapid heart rate'" do
      tag = FactoryGirl.create(:tag, name: 'Rapid heart rate')
      expect(tag.name).to eq('Rapid heart rate')
    end
  end

  describe "belonging to pathway" do
    let (:tag) { FactoryGirl.create(:tag) }
    let (:pathway) { tag.pathway }

    it "has a reference to the parent pathway" do
      expect(tag.pathway).to eq(pathway)
    end

    it "cannot have the same name as another tag belonging to the same pathway" do
      tag_with_duplicate_name = FactoryGirl.build(:tag, pathway: pathway, name: tag.name)
      expect(tag_with_duplicate_name).to_not be_valid
    end

    it "can have the same name as another tag belonging to another pathway" do
      tag_with_duplicate_name = FactoryGirl.build(:tag, name: tag.name)
      expect(tag_with_duplicate_name).to be_valid
    end
  end
end
