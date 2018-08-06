require 'spec_helper'

describe PathwaysController do
  describe 'GET #index' do
    it 'creates a new pathway instance for modal form' do
      get :index
      expect(assigns(:pathway)).to_not be_nil
    end
  end

  describe 'POST #create' do
    it 'returns success' do
      post :create, "pathway"=>{"name"=>"Tachycardia"}, "step1"=>"Button content", format: 'js'
      expect(response).to be_success
    end

    it 'sets form_step == 1 when first part of modal form is submitted' do
      post :create, "pathway"=>{"name"=>"Tachycardia"}, "step1"=>"Button content", format: 'js'
      expect(assigns(:form_step)).to eq(1)
    end

    it 'sets form_step == 2 when second part of modal form is submitted' do
      post :create, "pathway"=>{"name"=>"Tachycardia"}, "step2"=>"Button content", format: 'js'
      expect(assigns(:form_step)).to eq(2)
    end

    it 'creates tags with valid attributes' do
      post :create, {"pathway"=>{"name"=>"MyPathway", "tags_attributes"=>{
        "0"=>{"name"=>"t1", "_destroy"=>"false"}, "1"=>{"name"=>"t2", "_destroy"=>"false"}, 
        "2"=>{"name"=>"t3", "_destroy"=>"false"}}, "steps_attributes"=>{
          "0"=>{"name"=>"FirstStep"}}}, "step2"=>"Button text"}, format: 'js'
      pathway = Pathway.first
      expect(pathway.tags.count).to eq(3)
    end

    it 'creates step with valid attributes' do
      step_name = 'MyStep'
      post :create, {"pathway"=>{"name"=>"MyPathway", "tags_attributes"=>{
        "0"=>{"name"=>"t1", "_destroy"=>"false"}, "1"=>{"name"=>"t2", "_destroy"=>"false"}, 
        "2"=>{"name"=>"t3", "_destroy"=>"false"}}, "steps_attributes"=>{
          "0"=>{"name"=>step_name}}}, "step2"=>"Button text"}, format: 'js'
      pathway = Pathway.first
      expect(pathway.steps.first.name).to eq(step_name)
    end

    it 'does not create a pathway with missing pathway name' do
      post :create, {"pathway"=>{"name"=>"", "tags_attributes"=>{"0"=>{
        "name"=>"t1", "_destroy"=>"false"}, "1"=>{"name"=>"t2", "_destroy"=>"false"}, 
        "2"=>{"name"=>"t3", "_destroy"=>"false"}}, "steps_attributes"=>{
          "0"=>{"name"=>"FirstStep"}}}, "step2"=>"Button text"}, format: 'js'
      expect(Pathway.count).to eq(0)
    end

    it 'does create a pathway with missing tag name' do
      post :create, {"pathway"=>{"name"=>"MyPathway", "tags_attributes"=>{"0"=>{
        "name"=>"", "_destroy"=>"false"}, "1"=>{"name"=>"t2", "_destroy"=>"false"}, 
        "2"=>{"name"=>"t3", "_destroy"=>"false"}}, "steps_attributes"=>{
          "0"=>{"name"=>"FirstStep"}}}, "step2"=>"Button text"}, format: 'js'
      expect(Pathway.count).to eq(1)
    end

    it 'does not create a pathway with missing step name' do
      post :create, {"pathway"=>{"name"=>"MyPathway", "tags_attributes"=>{"0"=>{
        "name"=>"t1", "_destroy"=>"false"}, "1"=>{"name"=>"t2", "_destroy"=>"false"}, 
        "2"=>{"name"=>"t3", "_destroy"=>"false"}}, "steps_attributes"=>{
          "0"=>{"name"=>""}}}, "step2"=>"Button text"}, format: 'js'
      expect(Pathway.count).to eq(0)
    end
  end

  describe 'PUT #modal_edit' do
    let (:pathway) { FactoryGirl.create(:pathway) }
    let (:step) { FactoryGirl.create(:step, pathway: pathway) }
    let (:tag1) { FactoryGirl.create(:tag, pathway: pathway) }
    let (:tag2) { FactoryGirl.create(:tag, pathway: pathway) }
    let (:tag3) { FactoryGirl.create(:tag, pathway: pathway) }

    it 'returns success' do
      put :modal_edit, pathway: {name: 'NewPathwayName', tags_attributes: 
        {'0' => { name: "NewTagName1", _destroy: 'false', id: tag1.id}, 
        '1' => { name: "NewTagName2", _destroy: 'false', id: tag2.id}, 
        '2' => { name: "NewTagName3", _destroy: 'false', id: tag3.id } } }, 
        id: pathway.id, step_id: step.id, format: 'js'
      expect(response).to be_success
    end

    it 'loads the current step into @step' do
      put :modal_edit, pathway: {name: 'NewPathwayName', tags_attributes: 
        {'0' => { name: "NewTagName1", _destroy: 'false', id: tag1.id}, 
        '1' => { name: "NewTagName2", _destroy: 'false', id: tag2.id}, 
        '2' => { name: "NewTagName3", _destroy: 'false', id: tag3.id } } }, 
        id: pathway.id, step_id: step.id, format: 'js'
      expect(assigns(:step)).to eq(step)
    end

    it 'loads the current step pathway into @pathway' do
      put :modal_edit, pathway: {name: 'NewPathwayName', tags_attributes: 
        {'0' => { name: "NewTagName1", _destroy: 'false', id: tag1.id}, 
        '1' => { name: "NewTagName2", _destroy: 'false', id: tag2.id}, 
        '2' => { name: "NewTagName3", _destroy: 'false', id: tag3.id } } }, 
        id: pathway.id, step_id: step.id, format: 'js'
      expect(assigns(:pathway)).to eq(pathway)
    end

    context 'params are valid' do
      it 'updates pathway name' do
        name = 'Rapid Heart Rate'
        put :modal_edit, pathway: {name: name, tags_attributes: 
          {'0' => { name: tag1.name, _destroy: 'false', id: tag1.id}, 
          '1' => { name: tag2.name, _destroy: 'false', id: tag2.id}, 
          '2' => { name: tag3.name, _destroy: 'false', id: tag3.id } } }, 
          id: pathway.id, step_id: step.id, format: 'js'
        expect(pathway.reload.name).to eq(name)
      end

      it 'updates tag name' do
        new_tag_name = 'NewTag1Name'
        put :modal_edit, pathway: {name: pathway.name, tags_attributes: 
          {'0' => { name: new_tag_name, _destroy: 'false', id: tag1.id}, 
          '1' => { name: tag2.name, _destroy: 'false', id: tag2.id}, 
          '2' => { name: tag3.name, _destroy: 'false', id: tag3.id } } }, 
          id: pathway.id, step_id: step.id, format: 'js'
        expect(tag1.reload.name).to eq(new_tag_name)
      end

      it 'creates new tag' do
        put :modal_edit, pathway: {name: pathway.name, tags_attributes: 
          {'1442407498500' => { name: 'TagToCreate', _destroy: 'false' }, 
          '0' => { name: 'NewTag1Name', _destroy: 'false', id: tag1.id}, 
          '1' => { name: tag2.name, _destroy: 'false', id: tag2.id}, 
          '2' => { name: tag3.name, _destroy: 'false', id: tag3.id } } }, 
          id: pathway.id, step_id: step.id, format: 'js'
        expect(pathway.tags.count).to eq(4)
      end
    end

    context 'params are invalid' do
      it 'does not update with missing pathway name' do
        initial_name = pathway.name
        put :modal_edit, pathway: {name: '', tags_attributes: 
          {'0' => { name: tag1.name, _destroy: 'false', id: tag1.id}, 
          '1' => { name: tag2.name, _destroy: 'false', id: tag2.id}, 
          '2' => { name: tag3.name, _destroy: 'false', id: tag3.id } } }, 
          id: pathway.id, step_id: step.id, format: 'js'
        expect(pathway.reload.name).to eq(initial_name)
      end

      it 'does not update with missing tag name' do
        initial_name = tag1.name
        put :modal_edit, pathway: {name: pathway.name, tags_attributes: 
          {'0' => { name: '', _destroy: 'false', id: tag1.id}, 
          '1' => { name: tag2.name, _destroy: 'false', id: tag2.id}, 
          '2' => { name: tag3.name, _destroy: 'false', id: tag3.id } } }, 
          id: pathway.id, step_id: step.id, format: 'js'
        expect(tag1.reload.name).to eq(initial_name)
      end
    end
  end

  describe 'GET #step_titles' do
    let (:pathway) { FactoryGirl.create(:pathway) }
    let! (:step1) { FactoryGirl.create(:step, pathway: pathway) }
    let! (:step2) { FactoryGirl.create(:step, pathway: pathway) }

    it "has JSON object for each step" do
      get :step_titles, pathway_id: pathway.id, format: 'json'
      body = JSON.parse(response.body)
      expect(body.size).to eq(2)
    end
  end

  describe 'GET #autocomplete' do
    let! (:pathway) { FactoryGirl.create(:pathway, name: 'Tachycardia') }

    it "has JSON object for each pathway" do
      get :autocomplete, term: 'Cardia', format: 'json'
      body = JSON.parse(response.body)
      expect(body.size).to eq(1)
    end
  end

  describe 'GET #search' do
    let! (:pathway) { FactoryGirl.create(:pathway, name: 'Tachycardia') }

    it 'search result is nil if search term is blank' do
      get :search, term: ''
      expect(assigns(:pathways)).to be_nil
    end

    it 'search result is array of pathways if search term is not blank' do
      get :search, term: 'Achy'
      expect(assigns(:pathways)).to eq([pathway])
    end
  end

  describe 'GET #show' do
    let (:pathway) { FactoryGirl.create(:pathway, name: 'Tachycardia') }
    let! (:step1) { FactoryGirl.create(:step, pathway: pathway) }
    let! (:step2) { FactoryGirl.create(:step, pathway: pathway) }

    it 'returns success' do
      get :show, id: pathway.id
      expect(response).to be_success
    end

    it 'assigns first step in pathway to @first_step' do
      get :show, id: pathway.id
      expect(assigns(:first_step)).to eq(step1)
    end
  end
end
