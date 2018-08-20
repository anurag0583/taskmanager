class ProjectMailer < ApplicationMailer
	default from: 'notifications@example.com'
 
  def add_user_in_project(user,admin,project)
    @user = user
    @admin = admin
    @project = project
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Added user in project')
  end

  def remove_user(user,admin,project)
    @user = user
    @admin = admin
    @project = project
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Removed user from the project')
  end

end