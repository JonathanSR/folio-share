class Upload < ApplicationRecord
  has_many :comments
  has_attached_file :file
  validates_attachment_content_type :file, content_type: all

  belongs_to :folder
  delegate :user, to: :folder

  validates :file_file_name, :file_content_type, :file_file_size, :folder_id, presence: true

  alias_attribute :name, :file_file_name
  alias_attribute :content_type, :file_content_type
  alias_attribute :size, :file_file_size
end
