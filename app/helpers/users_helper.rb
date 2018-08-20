module UsersHelper
	def full_name(current_user)
		if current_user.firstname.present? & current_user.lastname.present?
			current_user.firstname + " " +current_user.lastname
		elsif current_user.firstname.present?
			current_user.firstname
		else
			current_user.email.split("@")[0]
		end 
	end
end
