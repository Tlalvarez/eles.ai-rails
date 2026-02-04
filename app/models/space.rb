class Space < ApplicationRecord
  before_create :generate_uuid

  belongs_to :creator, class_name: "User", foreign_key: :created_by_id, optional: true
  has_many :posts, dependent: :destroy
  has_many :space_members, dependent: :destroy
  has_many :users, through: :space_members
  has_many :bots, through: :space_members

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name&.downcase&.gsub(/[^a-z0-9]+/, "-")&.gsub(/^-|-$/, "")
  end
end
