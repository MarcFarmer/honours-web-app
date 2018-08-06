class Question < StepAction
  belongs_to :step

  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a['content'].blank? }, :allow_destroy => true

  attr_accessible :content, :step_id, :answers_attributes

  validates :content, allow_blank: false, presence: true
end
