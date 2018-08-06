class PathwaysController < ApplicationController
  autocomplete :step, :name, full: true

  def index
    @pathways = Pathway.limit(10)
    @pathway = Pathway.new
    @step = @pathway.steps.build(name: 'First step') # default name
  end

  def create
    @pathway = Pathway.new(params[:pathway])

    # submitting first part of new pathway form
    if params.has_key? :step1
      @form_step = 1

      if @pathway.valid?
        @valid = true
      else
        @valid = false
      end
    # submitting second part of new pathway form
    elsif params.has_key? :step2
      @form_step = 2

      if @pathway.save
        @valid = true
      else
        @valid = false
      end
    end

    # render error messages for form or go to the edit step page if form is complete
    respond_to do |format|
      format.js {}
    end
  end

  def show
    @pathway = Pathway.find(params[:id])
    @first_step = @pathway.steps.first
    @json_steps = @pathway.json_steps
  end

  def modal_edit
    @pathway = Pathway.find(params[:id])
    @step = Step.find(params[:step_id])

    respond_to do |format|
      if @pathway.update_attributes(params[:pathway])
        @pathway.reload # get updated pathway and tag names to render
        @valid = true
      else
        @valid = false
      end

      format.js {}
    end
  end

  def step_titles
    @pathway = Pathway.find(params[:pathway_id])
    steps = @pathway.steps
    steps.map! { |step| {title: step.name} }

    respond_to do |format|
      format.json {
        render json: steps
      }
    end
  end

  def autocomplete
    @pathways = Pathway.find_by_name_or_tag_like params[:term]

    json_results = []
    @pathways.each do |pathway|
      json_results << { label: pathway.name, value: pathway.name }
    end

    respond_to do |format|
      format.json {
        render json: json_results.to_json, root: false
      }
    end
  end

  def search
    @term = params[:term]

    @pathways = nil
    if !@term.blank?
      @pathways = Pathway.find_by_name_or_tag_like @term
    end

    respond_to do |format|
      format.js {}
    end
  end
end
