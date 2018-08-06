class Instruction < StepAction
  belongs_to :step
  attr_accessible :content, :step_id
  validates :content, allow_blank: false, presence: true
end
