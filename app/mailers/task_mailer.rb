class TaskMailer < ApplicationMailer
	default from: 'notifications@example.com'
 
	def add_task(user)
		@user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Added user in project') 	
	end
  
  def assign_task_to_user(admin,user,task,project)
    @admin = admin
    @user = user
    @task = task
    @project = project
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Added user in project')
  end
end
