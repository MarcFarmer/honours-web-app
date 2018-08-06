require 'spec_helper'

describe Pathway do
  describe "editing the name" do
    let(:pathway) { FactoryGirl.create(:pathway, name: 'Tachycardia') }

    it "can set name Tachycardia" do
      expect(pathway.name).to eq('Tachycardia')
    end

    it "requires a name" do
      nameless_pathway = FactoryGirl.build(:pathway, name: nil)
      expect(nameless_pathway).to_not be_valid
    end
  end

  describe "#tags" do
    let(:pathway) { FactoryGirl.create(:pathway, name: 'Tachycardia') }

    it "can add multiple tags to a pathway" do
      array = []
      tag1 = pathway.tags.create(name: 'Tag1')
      tag2 = pathway.tags.create(name: 'Tag2')
      tag3 = pathway.tags.create(name: 'Tag3')
      added_tags = [tag1, tag2, tag3]

      expect(pathway.tags).to eq(added_tags)
    end

    it "is invalid to have tags with the same name" do
      array = []
      pathway.tags.build(name: 'SameName')
      pathway.tags.build(name: 'SameName')

      expect(pathway).to_not be_valid
    end
  end

  describe "factory" do
    it "has a valid factory" do
      expect(FactoryGirl.create(:pathway)).to be_valid
    end
  end

  describe '#json_steps' do
    let! (:pathway) { FactoryGirl.create(:pathway, name: 'Tachycardia') }
    let! (:step) { FactoryGirl.create(:step, pathway: pathway, name: 'Is patient stable?') }
    let! (:step2) { FactoryGirl.create(:step, pathway: pathway) }
    let! (:step3) { FactoryGirl.create(:step, pathway: pathway) }
    let! (:ec1) { FactoryGirl.create(:exit_condition, step: step, exit_step: step2, min_risk: 0, max_risk: 0) }
    let! (:ec2) { FactoryGirl.create(:exit_condition, step: step, exit_step: step3, min_risk: 1, max_risk: 4) }
    let! (:question) { FactoryGirl.create(:question, step: ec1.exit_step) }
    let! (:instruction) { FactoryGirl.create(:instruction, step: ec1.exit_step) }

    it 'returns steps as JSON' do
      json_object = JSON.parse(pathway.json_steps)
      steps = json_object['steps']

      expect(steps.count).to eq(3)
    end
  end

  describe ".find_by_name_or_tag_like" do
    let! (:pathway1) { FactoryGirl.create(:pathway, name: 'Tachycardia') }
    let! (:pathway2) { FactoryGirl.create(:pathway, name: 'Tachy') }
    let! (:tag2) { FactoryGirl.create(:tag, name: 'cardia', pathway: pathway2) }
    let! (:pathway3) { FactoryGirl.create(:pathway, name: 'Sepsis') }
    let! (:tag3) { FactoryGirl.create(:tag, name: 'tachypnoea', pathway: pathway3) }

    it 'finds pathway by name or tag name' do
      results = Pathway.find_by_name_or_tag_like 'rdi'
      expected = [pathway1, pathway2]

      expect(results.sort).to eq(expected.sort)
    end

    it 'is not case sensitive' do
      results = Pathway.find_by_name_or_tag_like 'tAcHY'      
      expected = [pathway1, pathway2, pathway3]

      expect(results.sort).to eq(expected.sort)
    end

    it 'returns empty array if no pathways are found' do
      results = Pathway.find_by_name_or_tag_like 'ThisWontBeFound'
      expected = []

      expect(results).to eq(expected)
    end
  end
end
