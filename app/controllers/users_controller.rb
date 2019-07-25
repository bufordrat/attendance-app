class UsersController < ApplicationController

  include ApplicationHelper

  def dashboard
    @user = User.find_by(id: session["user_id"])
    security_check(@user)
    @previous_classes = ClassMeeting.up_to_present.pluck(:title).reverse 
    @students = User.where(is_teacher: false).order(:cnetid)
    @act_class_count = ClassMeeting.where(is_accepting: true).count  
  end

  def submit
    code_class = ClassMeeting.find_by(code: params["code"].to_i)
    activatedClass = ClassMeeting.find_by(is_accepting: true)
    if activatedClass == nil
      redirect_to "/users/#{params["id"]}", alert: "Failed assertion: no class is currently in session.  This means there's a bug in the software; please report what happened to your teacher."  # This message is deliberately incomphrensible to ordinary users because this situation is never supposed to arise.  
    else
      new_code = SubmittedCode.new
      new_code.code = params["code"]
      new_code.user_id = params["id"]
      if code_class != activatedClass
        new_code.is_legit = false
        new_code.save
        redirect_to "/users/#{params["id"]}", alert: "You must have mistyped your code."
      else
        new_code.is_legit = true
        p = Presence.new
        p.user_id = params["id"]
        p.class_meeting_id = activatedClass.id
        new_code.save
        p.save
        redirect_to "/users/#{params["id"]}", notice: "Congratulations. #{User.find_by(id: params["id"]).cnetid} is now checked in for #{activatedClass.title}."
      end
    end
  end

  
  def user_stories
  end
  
  def login
    if session["user_id"] != nil && User.find_by(id: session["user_id"]).is_teacher == true
      redirect_to "/dashboard"
    elsif session["user_id"] != nil && User.find_by(id: session["user_id"]).is_teacher == false
      redirect_to "/users/#{session["user_id"]}"
    else
    end
  end

  def student
    @user = User.find_by(id: session["user_id"])
    @params_user = User.find_by(id: params["id"])
    if @user == nil
      redirect_to root_url
      return
    end
    if @user.is_teacher == false && @user.id != params["id"].to_i
      redirect_to "/users/#{@user.id}", alert: "You are not allowed to view that page."
    elsif User.find_by(id: params["id"]).is_teacher == true
      redirect_to "/dashboard", alert: "The teacher has no absences page."
    else
    end
    @meeting = ClassMeeting.find_by(is_accepting: true) 
  end

  def new
  end

  def create
    user = User.new
    user.cnetid = params["cnetid"].downcase.strip
    user.is_teacher = false
    user.password = params["password"]
    user.id = User.pluck(:id).max + 1
    user.save
    if user.errors.full_messages.present?
      redirect_to '/users/new', notice: "#{user.errors.full_messages.map { |x| fix_error_message(x) }.uniq.join(", ")}."
    else
      session["user_id"] = user.id
      redirect_to "/users/#{user.id}", notice: "Welcome, #{user.cnetid}!"
    end
  end

  def roster 
    @user = User.find_by(id: session["user_id"])
    security_check(@user)
    @course = Course.first
    @student_array = User.where(is_teacher: false).order(:cnetid).to_a
  end

  def destroy 
    user = User.find_by(id: session["user_id"])
    security_check(user)
    marked_user = User.find_by(id: params["id"])
    dead_name = marked_user.cnetid
    marked_user.destroy
    redirect_to "/roster", notice: "Student with cnetid #{dead_name} deleted."
  end

  def edit
    security_check(User.find_by(id: session["user_id"]))
    @student = User.find_by(id: params["id"])
  end

  def update
    if User.find_by(id: session["user_id"]).is_teacher == true
      @student = User.find_by(id: params["id"])
      @student.cnetid = params["cnetid"]
      @student.is_teacher = false
      @student.password = params["password"]
      @student.save
      if @student.errors.full_messages.present?
        redirect_to "/users/#{@student.id}/edit", alert: "#{@student.errors.full_messages.map { |x| fix_error_message(x) }.join(", ")}."
      else
        redirect_to "/roster", notice: "You just changed the information for #{@student.cnetid}."
      end
    else
      redirect_to root_url, alert: "You are not authorized to do that."
    end
  end
  
end
