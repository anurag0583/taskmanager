class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable

 	has_attached_file :photo, :styles => { :small => "150x150>" },
                  :url  => "/assets/products/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/products/:id/:style/:basename.:extension",
                  :default_url => ":style/default-profile.jpg"

	# validates_attachment_presence :photo
	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :tasks
  has_many :comments
  # belongs_to :role
  
  ROLES = %w[admin manager employee].freeze
  # ROLE = ["Admin","Manager","Employee"]

  after_create :set_user_project
  before_create :setup_default_role_for_new_users

  private
  def set_user_project
    self.projects.create(:name=> "persnal_project",:created_by_id =>self.id)
  end

  def setup_default_role_for_new_users
    if self.role.blank?
      self.role = "Employee"
    end
  end
end