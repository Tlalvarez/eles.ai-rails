class BotApiToken < ApplicationRecord
  before_create :generate_uuid

  belongs_to :bot

  validates :token, presence: true, uniqueness: true
end
