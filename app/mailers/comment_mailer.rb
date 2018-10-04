class CommentMailer < ApplicationMailer
	default from: 'Task Manager<info@taskmanager.com>'
 
  def post_comment(user,task,project,comment)
    @user = user
    @task = task
    @project = project
    @comment = comment
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Comment Added')
  end
end