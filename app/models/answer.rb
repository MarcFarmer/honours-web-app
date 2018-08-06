class Answer < ActiveRecord::Base
  belongs_to :question
  attr_accessible :content, :question_id, :score
  validates :content, allow_blank: false, presence: true
end
