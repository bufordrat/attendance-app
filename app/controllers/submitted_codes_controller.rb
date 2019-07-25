class SubmittedCodesController < ApplicationController

  include ApplicationHelper
  
  def submissions
    security_check(User.find_by(id: session["user_id"]))
    @course = Course.first
    @students = User.where(is_teacher: false).order(:cnetid).pluck(:cnetid)
  end
  
end
