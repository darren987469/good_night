class Sleep < ApplicationRecord
  belongs_to :user

  validate :overlap

  private

  def overlap
    return unless slept_at && waked_at && overlap?
    errors.add(:base, 'The sleep is overlapped with other one.')
  end

  def overlap?
    Sleep.where(user_id: user_id).
      where('slept_at < ? AND ? < waked_at', waked_at, slept_at).exists?
  end
end
