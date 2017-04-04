class Folder < ApplicationRecord
  belongs_to :user
  belongs_to :parent, class_name: "Folder", optional: true

  has_many :subfolders, class_name: "Folder", foreign_key: "parent_id"
  has_many :uploads
  has_many :collaborations, dependent: :destroy
  has_many :collaborators, through: :collaborations, source: :user

  validates :name,   presence: true
  validates :status, presence: true

  alias_attribute :owner, :user

  enum ({status: [:active, :inactive]})
  
  def ancestors(list = [])
    unless parent_id.nil?
      list.unshift(parent)
      parent.ancestors(list)
    end
    list
  end

  def children
    children = subfolders.to_a.concat(uploads.to_a)
    children.sort_by { |child| child.name.downcase }
  end

  def all_uploads(list = [])
    return user.uploads if root_folder?
    list.concat(uploads)
    unless subfolders.nil?
      subfolders.each { |subfolder| subfolder.all_uploads(list) }
    end
    list
  end

  def root_folder?
    parent.nil?
  end

  def content_type
    ""
  end

  def size
    ""
  end

  def display_privacy
    ""
  end

  def download
    ZipGenerator.new(self).download
  end
end
