module ApplicationHelper

  def security_check(user)
    if user.blank?
      redirect_to root_url, alert: "You are not allowed to view that page."
    elsif user.is_teacher == false
      redirect_to "/users/#{user.id}", alert: "You are not allowed to view that page."
      return
    end
  end

  def fix_error_message(message)
    if message == "Meeting can't be blank"
      return "Please enter a date in YYYY-MM-DD format"
    elsif message == "Cnetid can't be blank"
      return "Please enter a valid cnetid"
    elsif message == "Title can't be blank"
      return "Please enter a non-blank class meeting title"
    elsif message == "Code can't be blank"
      return "Please enter a non-blank code"
    elsif message == "Code is not a number"
      return "Please enter a four-digit numeric code"
    elsif message == "Password can't be blank" || message == "Password digest can't be blank"
      return "Please enter a non-blank password"
    elsif message == "Code has already been taken"
      return "Please enter a new code not already taken by another class meeting"
    elsif message == "Code must be less than 10000"
      return "Please enter a code between 1000 and 9999"
    elsif message == "Code must be greater than 1000"
      return "Please enter a code between 1000 and 9999"
    elsif message == "Cnetid has already been taken"
      return "You should log in, because that cnetid already has an account"
    else
      return message
    end
  end

  def fix_boolean(bool)
    if bool == true
      return "valid"
    else
      return "NOT VALID"
    end
  end
  
end
