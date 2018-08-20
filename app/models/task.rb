class Task < ApplicationRecord
	has_and_belongs_to_many :users
	has_many :comments
	belongs_to :project

	has_attached_file :document
	validates_attachment :document, presence: true,
    content_type: { content_type: ["application/pdf", "application/doc", "application/docx",
    "image/jpeg", "image/gif", "image/png", "image/jpg", "image/bmp"] },
    size: { in: 1..5000.kilobytes }

	STATUS = ["to do","in progress","ready for testing","done"]
	PRIORITY = ["High", "Medium", "Low"]
end
