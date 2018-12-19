class Project < ApplicationRecord
	
	validates :name, presence: true
	
	has_and_belongs_to_many :users
	has_many :tasks

	def self.search(search)
	  if search
	    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
	  else
	    find(:all)
	  end
	end
end
