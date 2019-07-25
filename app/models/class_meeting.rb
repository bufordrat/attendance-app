class ClassMeeting < ApplicationRecord

  belongs_to :course

  validates :meeting, presence: true
  validates :code, presence: true, uniqueness: true, numericality: { greater_than: 1000, less_than: 10000 } 
  validates :course_id, presence: true
  validates :is_accepting, exclusion: { in: [nil] }
  validates :title, presence: true
  
  def ClassMeeting.up_to_present
    return ClassMeeting.where('meeting <= ?', DateTime.now)
  end

  def ClassMeeting.unique_code(array)
    code = rand(1000...9999)
    if array.include?(code)
      ClassMeeting.unique_code(array)
    else
      return code
    end
  end
  
end
