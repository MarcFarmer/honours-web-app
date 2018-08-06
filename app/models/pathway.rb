class Pathway < ActiveRecord::Base
  include ActionView::Helpers::TextHelper

  has_many :steps, :dependent => :destroy
  has_many :tags, :dependent => :destroy
 
  accepts_nested_attributes_for :steps, allow_destroy: true
  accepts_nested_attributes_for :tags, :reject_if => lambda { |a| a['name'].blank? }, :allow_destroy => true
  
  attr_accessible :name, :steps_attributes, :tags_attributes
  validates :name, allow_blank: false, presence: true
  validates_uniqueness_of :name

  validate :uniqueness_of_tag_names

  default_scope order('created_at DESC')

  # build json arrays of all steps and exit conditions in the pathway
  # return arrays as a json string
  def json_steps
    exit_conditions_array = Array.new
    steps_array = Array.new

    # add each step in this pathway, and it's exit conditions
    self.steps.each do |step|
      step.exit_conditions.each do |exit_condition|
        exit_conditions_array << {
          step: exit_condition.step.name,
          exit_step: exit_condition.exit_step.name,
          min: exit_condition.min_risk,
          max: exit_condition.max_risk
        }
      end

      step_actions_content = String.new
      step.step_actions.each do |step_action|
        step_actions_content << '\n'
        step_actions_content << truncate(step_action.content, length: 35, omission: '...')
      end

      steps_array << {
        title: step.name,
        id: step.id,
        actions: step.step_actions.count,
        content: step_actions_content
      }
    end

    pathway_hash = {
      exit_conditions: exit_conditions_array,
      steps: steps_array
    }

    # convert array of hashes to json string
    return pathway_hash.to_json
  end

  def self.find_by_name_or_tag_like(string)
    like_string = "%#{string.downcase}%"
    pathways_by_name = Pathway.where('lower(name) LIKE ?', like_string)
    pathways_by_tag_name = []
    Tag.where('lower(name) LIKE ?', like_string).each do |tag|
      pathways_by_tag_name << tag.pathway
    end

    return (pathways_by_name | pathways_by_tag_name).sort! { |a,b| a.name.downcase <=> b.name.downcase }
  end

  private
  def uniqueness_of_tag_names
    tag_names = self.tags.map do |tag|
      tag.name
    end

    if tag_names != tag_names.uniq
      errors.add(:tags, "^Cannot have duplicate tags")
    end
  end
end
