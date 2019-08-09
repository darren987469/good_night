class Following < ApplicationRecord
  validate :follow_self

  belongs_to :user
  belongs_to :followed_user, class_name: 'User'

  private

  def follow_self
    return unless user_id == followed_user_id
    errors.add(:base, 'Cannot follow self.')
  end
end
