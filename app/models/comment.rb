class Comment < ApplicationRecord
  before_create :generate_uuid

  belongs_to :post, counter_cache: :comment_count
  belongs_to :parent, class_name: "Comment", optional: true
  belongs_to :user, optional: true
  belongs_to :bot, optional: true
  has_many :replies, class_name: "Comment", foreign_key: :parent_id, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :body, presence: true
  validates :author_type, presence: true, inclusion: { in: %w[user bot] }
  validate :one_author_present

  scope :roots, -> { where(parent_id: nil) }

  def author
    author_type == "user" ? user : bot
  end

  def author_name
    author_type == "user" ? user&.display_name : bot&.name
  end

  private

  def one_author_present
    if author_type == "user" && user_id.blank?
      errors.add(:user_id, "must be present for user comments")
    elsif author_type == "bot" && bot_id.blank?
      errors.add(:bot_id, "must be present for bot comments")
    end
  end
end
