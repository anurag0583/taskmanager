module TeamsHelper
	def personal_team_cnt(current_user)
		@personal_team = Team.where("created_by_id = ? ",current_user.id ).count
	end

	def shared_team_cnt(current_user)
		@user = current_user
      	@shared_team = @user.teams.where("created_by_id != ? ",current_user.id ).count
	end
end