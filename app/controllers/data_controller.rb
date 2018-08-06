class DataController < ApplicationController
  def index
    params.each do |key, value|
      if key == "pathway"
        @pathway = Pathway.where('name ILIKE ?', value).first
      end
    end

    @container = Hash.new

    if @pathway.nil?
      respond_to do |format|
          format.json { render json: @container.to_json }
      end
    else

      @container[:pathway] = @pathway.name

      i = 0
      @container[:steps] = Array.new

      @pathway.steps.each do |step|
        @container[:steps][i] = Hash.new
        @container[:steps][i][:name] = step.name 

        @container[:steps][i][:step_actions] = Array.new

        j = 0
        step.step_actions.each do |sa|
          @container[:steps][i][:step_actions][j] = Hash.new

          if sa.type == "Instruction"
            @container[:steps][i][:step_actions][j][:type] = 'I'
            @container[:steps][i][:step_actions][j][:content] = sa.content
          elsif sa.type == "Question"
            if sa.answers.count == 2
              yesFound = false
              noFound = false
              sa.answers.each do |a|
                a_lowercase = a.content.downcase
                if a_lowercase == "yes"
                  yesFound = true
                elsif a_lowercase == "no"
                  noFound = true
                end
              end

              if yesFound && noFound
                @container[:steps][i][:step_actions][j][:type] = 'YNQ'
                @container[:steps][i][:step_actions][j][:content] = sa.content
              else
                @container[:steps][i][:step_actions][j][:type] = 'MCQ'
                @container[:steps][i][:step_actions][j][:content] = sa.content
              end
            else
              @container[:steps][i][:step_actions][j][:type] = 'MCQ'
              @container[:steps][i][:step_actions][j][:content] = sa.content

            end

            @container[:steps][i][:step_actions][j][:answers] = Array.new
            k = 0
            sa.answers.each do |a|
              @container[:steps][i][:step_actions][j][:answers][k] = Hash.new
              @container[:steps][i][:step_actions][j][:answers][k][:content] = a.content
              @container[:steps][i][:step_actions][j][:answers][k][:score] = a.score
              k = k + 1
            end
          end
          j = j + 1
        end

        j = 0
        @container[:steps][i][:exit_conditions] = Array.new
        step.exit_conditions.each do |ec|
          @container[:steps][i][:exit_conditions][j] = Hash.new
          @container[:steps][i][:exit_conditions][j][:min_risk] = ec.min_risk
          @container[:steps][i][:exit_conditions][j][:max_risk] = ec.max_risk
          @container[:steps][i][:exit_conditions][j][:step_name] = Pathway.where(name: @pathway.name).first.steps.find(ec.exit_step_id.to_i).name
          j = j + 1
        end

        i = i + 1
      end

      respond_to do |format|
          format.json { render json: @container.to_json }
      end
    end
  end

  def search
    params.each do |key, value|
      if key == "pathway"
        @search_term = value
      end
    end

    @container = Array.new
    @pathways = Pathway.find_by_name_or_tag_like(@search_term)
    @pathways.each do |pathway|
      @container << pathway.name
    end

    respond_to do |format|
        format.json { render json: @container.to_json }
    end
  end
end
