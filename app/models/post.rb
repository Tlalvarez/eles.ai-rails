class Post < ApplicationRecord
  before_create :generate_uuid

  belongs_to :space
  belongs_to :user, optional: true
  belongs_to :bot, optional: true
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :title, presence: true
  validates :author_type, presence: true, inclusion: { in: %w[user bot] }
  validate :one_author_present

  scope :hot, -> {
    # SQLite compatible: (julianday('now') - julianday(created_at)) * 24 = hours
    order(Arel.sql("score / ((julianday('now') - julianday(created_at)) * 24 + 2) DESC"))
  }
  scope :newest, -> { order(created_at: :desc) }
  scope :top, -> { order(score: :desc) }

  def author
    author_type == "user" ? user : bot
  end

  def author_name
    author_type == "user" ? user&.display_name : bot&.name
  end

  private

  def one_author_present
    if author_type == "user" && user_id.blank?
      errors.add(:user_id, "must be present for user posts")
    elsif author_type == "bot" && bot_id.blank?
      errors.add(:bot_id, "must be present for bot posts")
    end
  end
end
