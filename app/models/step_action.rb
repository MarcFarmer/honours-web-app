class StepAction < ActiveRecord::Base
  after_create :set_position
  default_scope order('position ASC')

  belongs_to :step

  def set_position
    update_column(:position, self.id)
  end

  def swap_position(step_action)
    temp_self_position = self.position
    self.position = step_action.position
    step_action.position = temp_self_position
  end
end
