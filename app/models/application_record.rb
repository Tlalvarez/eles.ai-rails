class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  private

  def generate_uuid
    self.id ||= SecureRandom.uuid
  end
end
