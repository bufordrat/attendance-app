class ClassMeetingsController < ApplicationController

  include ApplicationHelper
  
  def activate
    if User.find_by(id: session["user_id"]).is_teacher == true 
      meeting = ClassMeeting.find_by(title: params["meeting"])
      if meeting != nil
        meeting.is_accepting = true
        meeting.save
        redirect_to '/dashboard'
      else
        redirect_to '/dashboard', alert: "You must choose a class meeting to activate."
      end
    else
      redirect_to "/users/#{session["user_id"].to_s}", alert: "You are not authorized to do that."      
    end
  end

  def deactivate
    if User.find_by(id: session["user_id"]).is_teacher == true 
      meeting = ClassMeeting.find_by(id: params["id"])
      meeting.is_accepting = false
      meeting.save
      redirect_to '/dashboard'
    else
      redirect_to "/users/#{session["user_id"].to_s}", alert: "You are not authorized to do that."
    end
  end

  def index
    @user = User.find_by(id: session["user_id"])
    security_check(@user)
    @course_name = Course.first.title
    @meeting_array = ClassMeeting.all.order(:meeting).to_a
  end

  def create
    if User.find_by(id: session["user_id"]).is_teacher == true 
      new_meeting = ClassMeeting.new
      new_meeting.meeting = params["meeting"]
      new_meeting.title = params["title"]
      new_meeting.code = ClassMeeting.unique_code(ClassMeeting.pluck(:code))
      new_meeting.course_id = Course.first.id    # TODO: this is for some later version of the app after the Web Development final project, but eventually parameterize this on the course
      new_meeting.is_accepting = false
      new_meeting.id = ClassMeeting.pluck(:id).max + 1
      new_meeting.save
      if new_meeting.errors.full_messages.present?
        redirect_to '/class_meetings', alert: "#{new_meeting.errors.full_messages.map { |x| fix_error_message(x) }.join(", ")}."
      else
        redirect_to '/class_meetings', notice: "You have just added a class called #{new_meeting.title}." 
      end
    else
      redirect_to "/users/#{session["user_id"].to_s}", alert: "You are not authorized to do that."
    end
  end

  def destroy
    if User.find_by(id: session["user_id"]).is_teacher == true 
      meeting = ClassMeeting.find_by(id: params["id"])
      meeting.delete
      redirect_to "/class_meetings", notice: "#{meeting.title} deleted."
    else
      redirect_to "/users/#{session["user_id"].to_s}", alert: "You are not authorized to do that."
    end
  end

  def edit
    security_check(User.find_by(id: session["user_id"]))
    @meeting = ClassMeeting.find_by(id: params["id"])
  end

  def update
    if User.find_by(id: session["user_id"]).is_teacher == true 
      @meeting = ClassMeeting.find_by(id: params["id"])
      @meeting.meeting = params["meeting"]
      @meeting.title = params["title"]
      @meeting.code = params["code"]
      @meeting.is_accepting = @meeting.is_accepting
      @meeting.course_id = @meeting.course_id
      @meeting.save
      if @meeting.errors.full_messages.present?
        redirect_to "/class_meetings/#{@meeting.id}/edit", alert: "#{@meeting.errors.full_messages.map { |x| fix_error_message(x) }.join(", ") }."
      else
        redirect_to '/class_meetings', notice: "You just changed the #{@meeting.title} meeting."  
      end
    else
      redirect_to "/users/#{session["user_id"].to_s}", alert: "You are not authorized to do that." 
    end
  end
  
end
