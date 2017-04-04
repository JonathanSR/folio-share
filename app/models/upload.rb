class Upload < ApplicationRecord
  include PrivacySettings

  mount_uploader :attachment, AttachmentUploader

  belongs_to :folder
  delegate :user, to: :folder
  has_many :comments

  # validates :attachment, presence: true, file_size: { maximum: 2.gigabytes }
  # validates :attachment, presence: true

  validates :name, presence: true
  validates :content_type, presence: true
  validates :size, presence: true
  validates :folder_id, presence: true

  def all_uploads
    [self]
  end

  def ancestors
    folder.ancestors << folder
  end

  def directory
    ancestors.map(&:name).join("/")
  end

  def folio_filepath
    "#{directory}/#{name}"
  end

  def local_filepath
    attachment.file.file
  end

  def owner
    folder.owner
  end

  def parent
    folder
  end

  def self.public_uploads
    Upload.where(is_private: false)
  end
end
