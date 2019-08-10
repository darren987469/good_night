module Entity
  module V1
    class SleepWithUser < Sleep
      include ActionView::Helpers::DateHelper

      expose :user, using: Entity::V1::User
      expose :sleep_length, documentation: { type: String }

      def sleep_length
        distance_of_time_in_words(object.slept_at, object.waked_at)
      end
    end
  end
end
