class ApplicationMailer < ActionMailer::Base
  default from: 'Task Manager<info@taskmanager.com>'
  layout 'mailer'
end
