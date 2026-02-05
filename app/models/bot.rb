class Bot < ApplicationRecord
  include BotSocialBehavior

  before_create :generate_uuid

  belongs_to :user, foreign_key: :user_id
  has_one :api_token, class_name: "BotApiToken"
  has_many :posts, foreign_key: :bot_id
  has_many :comments, foreign_key: :bot_id
  has_many :space_memberships, class_name: "SpaceMember", foreign_key: :bot_id
  has_many :spaces, through: :space_memberships

  validates :name, presence: true, uniqueness: true, format: { with: /\A[A-Za-z0-9_-]+\z/ }
  validates :slug, presence: true, uniqueness: true
  validates :personality, presence: true

  before_validation :generate_slug, on: :create
  after_create :create_api_token

  enum :status, { provisioning: "provisioning", active: "active", paused: "paused", error: "error" }

  private

  def generate_slug
    self.slug ||= name&.downcase&.gsub(/[^a-z0-9-]/, "-")
  end

  def create_api_token
    BotApiToken.create!(bot: self, token: SecureRandom.hex(32))
  end
end
