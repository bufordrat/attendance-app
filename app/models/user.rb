class User < ApplicationRecord

  has_many :submitted_codes, dependent: :destroy
  has_many :presences, dependent: :destroy

  has_secure_password

  validates :is_teacher, exclusion: { in: [nil] }
  validates :cnetid, uniqueness: true, presence: true
  validates :password_digest, presence: true
  
  def absence_array
    previous_classes = ClassMeeting.up_to_present.ids
    user_presences = User.find_by(id: self.id).presences.pluck(:class_meeting_id)
    absences = previous_classes - user_presences
    return absences
  end
  
end
