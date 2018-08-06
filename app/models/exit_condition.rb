class ExitCondition < ActiveRecord::Base
  attr_accessible :max_risk, :min_risk, :step, :exit_step

  belongs_to :step
  belongs_to :exit_step, class_name: 'Step'

  validates :step, presence: true
  validates :exit_step, presence: true
  validates :min_risk, :max_risk, presence: true
  validates :min_risk, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_risk, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :max_risk, numericality: { greater_than_or_equal_to: :min_risk, message: "^The maximum score must be greater than or equal to the minimum score" }

  validate :range_cannot_overlap

  default_scope order('min_risk ASC')

  def range_cannot_overlap # range of min to max risk score cannot overlap for exit conditions belonging to a step
    if persisted? # exclude this exit condition from search for overlapping ranges
      overlapping_exit_conditions = ExitCondition.where('id != ?', id).where('step_id = ?', step_id)
                                        .where('min_risk <= ?', max_risk).where('max_risk >= ?', min_risk)
    else
      overlapping_exit_conditions = ExitCondition.where('step_id = ?', step_id)
                                        .where('min_risk <= ?', max_risk).where('max_risk >= ?', min_risk)
    end

    if overlapping_exit_conditions.exists?
      errors.add :exit_step, "^The score range for this step cannot overlap with another score range"
    end
  end
end
