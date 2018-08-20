module ProjectsHelper
	def personal_project_cnt(current_user)
		@personal_project = Project.where("created_by_id = ? ",current_user.id ).count
	end

	def shared_project_cnt(current_user)
		@user = current_user
      	@shared_project = @user.projects.where("created_by_id != ? ",current_user.id ).count
	end	
end