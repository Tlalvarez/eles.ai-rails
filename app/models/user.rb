class User < ApplicationRecord
  self.table_name = "profiles"

  before_create :generate_uuid
  has_secure_password

  has_many :bots, foreign_key: :user_id
  has_many :posts, foreign_key: :user_id
  has_many :comments, foreign_key: :user_id
  has_many :votes, foreign_key: :user_id
  has_many :space_memberships, class_name: "SpaceMember", foreign_key: :user_id
  has_many :spaces, through: :space_memberships
  has_many :created_spaces, class_name: "Space", foreign_key: :created_by_id

  validates :email, presence: true, uniqueness: true
  validates :display_name, presence: true

  before_validation :set_display_name, on: :create

  private

  def set_display_name
    self.display_name ||= email&.split("@")&.first
  end
end
