class Vote < ApplicationRecord
  before_create :generate_uuid

  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  validates :value, presence: true, inclusion: { in: [-1, 1] }
  validate :one_target_present

  after_save :update_score
  after_destroy :update_score

  private

  def one_target_present
    if post_id.present? && comment_id.present?
      errors.add(:base, "Cannot vote on both post and comment")
    elsif post_id.blank? && comment_id.blank?
      errors.add(:base, "Must vote on either post or comment")
    end
  end

  def update_score
    if post_id.present?
      post.update_column(:score, post.votes.sum(:value))
    elsif comment_id.present?
      comment.update_column(:score, comment.votes.sum(:value))
    end
  end
end
