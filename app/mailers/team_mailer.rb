class TeamMailer < ApplicationMailer
	default from: 'Task Manager<info@taskmanager.com>'
 
  def add_user(admin,user,team)
    @admin = admin
    @user = user
    @team = team
    # @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Added user in team')
  end

  def remove_user(admin,user,team)
    @admin = admin
    @user = user
    @team = team
    # @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Removed user from the team')
  end

end
