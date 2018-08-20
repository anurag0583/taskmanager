class Team < ApplicationRecord
	has_and_belongs_to_many :users
	
	DEPARTMENT = ["IT","Computer","HR","Managment"]
end