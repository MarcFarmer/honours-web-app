require 'spec_helper'

describe DataController do

  describe "GET 'index'" do
    it "check valid JSON string with non-existent pathway name" do
      request.accept = "application/json"
      get :index, pathway: 'Pathway 1'
      expect(response.body).to eq('{}')
    end

    it "check valid JSON string with one Y/N question" do
      p = Pathway.create(name: "Pathway 1")
      s1 = p.steps.create(name: "Step 1")
      q1 = s1.questions.create(content: "Are you sick?")
      q1.answers.create(content: "Yes", score: 1)
      q1.answers.create(content: "No", score: 0)

      request.accept = "application/json"
      get :index, pathway: 'Pathway 1'
      expect(response.body).to eq('{"pathway":"Pathway 1","steps":[{"name":"Step 1","step_actions":[{"type":"YNQ","content":"Are you sick?","answers":[{"content":"Yes","score":1},{"content":"No","score":0}]}],"exit_conditions":[]}]}')
    end

    it "check valid JSON string with one multiple choice question with 3 answers" do
      p = Pathway.create(name: "Pathway 1")
      s1 = p.steps.create(name: "Step 1")
      q1 = s1.questions.create(content: "Age?")
      q1.answers.create(content: "< 10", score: 2)
      q1.answers.create(content: "11-21", score: 1)
      q1.answers.create(content: "> 22", score: 0)

      request.accept = "application/json"
      get :index, pathway: 'Pathway 1'
      expect(response.body).to eq('{"pathway":"Pathway 1","steps":[{"name":"Step 1","step_actions":[{"type":"MCQ","content":"Age?","answers":[{"content":"\u003C 10","score":2},{"content":"11-21","score":1},{"content":"\u003E 22","score":0}]}],"exit_conditions":[]}]}')
    end

    it "check valid JSON string with one multiple choice question with 2 answers" do
      p = Pathway.create(name: "Pathway 1")
      s1 = p.steps.create(name: "Step 1")
      q1 = s1.questions.create(content: "Age?")
      q1.answers.create(content: "< 10", score: 2)
      q1.answers.create(content: "> 11", score: 1)

      request.accept = "application/json"
      get :index, pathway: 'Pathway 1'
      expect(response.body).to eq('{"pathway":"Pathway 1","steps":[{"name":"Step 1","step_actions":[{"type":"MCQ","content":"Age?","answers":[{"content":"\u003C 10","score":2},{"content":"\u003E 11","score":1}]}],"exit_conditions":[]}]}')
    end

    it "check valid JSON string with one instruction" do
      p = Pathway.create(name: "Pathway 1")
      s1 = p.steps.create(name: "Step 1")
      i1 = s1.instructions.create(content: "Check ABCs")

      request.accept = "application/json"
      get :index, pathway: 'Pathway 1'
      expect(response.body).to eq('{"pathway":"Pathway 1","steps":[{"name":"Step 1","step_actions":[{"type":"I","content":"Check ABCs"}],"exit_conditions":[]}]}')
    end

    it "check valid JSON string with one exit condition" do
      p = Pathway.create(name: "Pathway 1")
      s1 = p.steps.create(name: "Step 1")
      ec1 = s1.exit_conditions.create(step: s1, exit_step: s1, min_risk: 0, max_risk: 1)

      request.accept = "application/json"
      get :index, pathway: 'Pathway 1'
      expect(response.body).to eq('{"pathway":"Pathway 1","steps":[{"name":"Step 1","step_actions":[],"exit_conditions":[{"min_risk":0,"max_risk":1,"step_name":"Step 1"}]}]}')
    end
  end

  describe "GET 'search'" do
    it "check valid JSON string with an existing pathway" do
      p = Pathway.create(name: "Pathway 1")

      request.accept = "application/json"
      get :search, pathway: 'Pathway 1'
      expect(response.body).to eq('["Pathway 1"]')
    end
  end
end
