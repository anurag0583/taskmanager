class HardWorker
  include Sidekiq::Worker

 def perform(u,admin,team)
  	ProjectMailer.add_user_in_project(u,admin,team).deliver_later
    # Do something
  end
end
