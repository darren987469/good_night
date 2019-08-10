class Sleep < ApplicationRecord
  belongs_to :user

  validate :overlap

  private

  def overlap
    return unless overlap_record_exists?
    errors.add(:base, 'The sleep is overlapped with other one.')
  end

  def overlap_record_exists?
    return unless user_id && slept_at && waked_at
    record = Sleep.where(user_id: user_id).
      where('slept_at <= ? AND ? <= waked_at', waked_at, slept_at)
    record = record.where.not(id: id) if persisted?
    record.exists?
  end
end
