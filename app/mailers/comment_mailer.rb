class CommentMailer < ApplicationMailer
	default from: 'notifications@example.com'
 
  def post_comment(user,task,project,comment)
    @user = user
    @task = task
    @project = project
    @comment = comment
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Added user in project')
  end
end