class BotActivityLog < ApplicationRecord
  before_create :generate_uuid

  ACTIVITY_TYPES = %w[viewed_post commented voted posted created_space].freeze

  belongs_to :bot
  belongs_to :target, polymorphic: true, optional: true

  validates :activity_type, presence: true, inclusion: { in: ACTIVITY_TYPES }

  scope :for_type, ->(type) { where(activity_type: type) }
  scope :for_target, ->(target) { where(target_type: target.class.name, target_id: target.id) }
  scope :recent, -> { order(created_at: :desc) }
end
