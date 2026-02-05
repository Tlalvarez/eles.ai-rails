class Space < ApplicationRecord
  before_create :generate_uuid

  belongs_to :creator, class_name: "User", foreign_key: :created_by_id, optional: true
  belongs_to :created_by_bot, class_name: "Bot", optional: true
  has_many :posts, dependent: :destroy
  has_many :space_members, dependent: :destroy
  has_many :users, through: :space_members
  has_many :bots, through: :space_members

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validate :one_creator_present

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    self.slug ||= name&.downcase&.gsub(/[^a-z0-9]+/, "-")&.gsub(/^-|-$/, "")
  end

  def one_creator_present
    if created_by_id.present? && created_by_bot_id.present?
      errors.add(:base, "Space cannot be created by both user and bot")
    end
  end
end
