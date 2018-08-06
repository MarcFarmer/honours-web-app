class Step < ActiveRecord::Base
  belongs_to :pathway

  has_many :step_actions, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :instructions, :dependent => :destroy

  accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a['content'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :instructions, :reject_if => lambda { |a| a['content'].blank? }, :allow_destroy => true

  has_many :exit_conditions, :dependent => :destroy
  has_many :exit_steps, through: :exit_conditions

  attr_accessible :name, :questions_attributes, :instructions_attributes, :exit_conditions_attributes

  accepts_nested_attributes_for :exit_conditions, allow_destroy: true

  validates :name, allow_blank: false, presence: true

  default_scope order('created_at ASC')

  # find the answer with the lowest score for each question that belongs to the step, then return the sum
  # do the same calculation for the sum of highest answer scores for each question
  def score_sums
    min_score = 0
    max_score = 0

    questions.each do |question|
      answers = question.answers
      next if answers.empty?

      first_answer_score = answers.shift.score # remove first answer and get score
      current_min_score = first_answer_score
      current_max_score = first_answer_score

      answers.each do |answer|
        if answer.score < current_min_score
          current_min_score = answer.score
        end
        if answer.score > current_max_score
          current_max_score = answer.score
        end
      end

      min_score += current_min_score
      max_score += current_max_score
    end

    return min_score, max_score
  end
end
