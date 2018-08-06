class Tag < ActiveRecord::Base
  belongs_to :pathway
  attr_accessible :name
  validates :name, allow_blank: false, presence: true
  validates_uniqueness_of :name, scope: :pathway_id
end
