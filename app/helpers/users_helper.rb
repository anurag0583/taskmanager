module UsersHelper
	def full_name(current_user)
		if current_user.firstname.present? & current_user.lastname.present?
			current_user.firstname.capitalize + " " +current_user.lastname.capitalize
		elsif current_user.firstname.present?
			current_user.firstname.capitalize
		else
			current_user.email.split("@")[0].capitalize
		end 
	end
end
