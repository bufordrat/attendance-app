class Presence < ApplicationRecord

  belongs_to :user
  belongs_to :class_meeting
  
  has_many :users

  validates :user_id, presence: true
  validates :class_meeting_id, presence: true
  
end
