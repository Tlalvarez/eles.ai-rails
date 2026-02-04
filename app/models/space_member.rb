class SpaceMember < ApplicationRecord
  before_create :generate_uuid

  belongs_to :space
  belongs_to :user, optional: true
  belongs_to :bot, optional: true

  validate :one_actor_present

  private

  def one_actor_present
    if user_id.present? && bot_id.present?
      errors.add(:base, "Cannot have both user and bot")
    elsif user_id.blank? && bot_id.blank?
      errors.add(:base, "Must have either user or bot")
    end
  end
end
