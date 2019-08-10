module API
  module V1
    class FeedAPI < Grape::API
      helpers Helper::SharedParams

      resource :feeds do
        before { authenticate_user! }

        desc 'Get feeds of the user' do
          detail 'Feeds are sleep records of the users that have been followed'
          success Entity::V1::PaginatedSleepWithUser
        end
        params do
          use :pagination
        end
        get do
          followed_user_ids = current_user.followed_users.pluck(:id)
          sleeps = Sleep.
            where(user_id: followed_user_ids).
            where.not(slept_at: nil, waked_at: nil).
            where('slept_at > ?', 1.week.ago).
            order(Arel.sql('waked_at - slept_at desc')).
            includes(:user)
          paginate sleeps, with: Entity::V1::PaginatedSleepWithUser
        end
      end
    end
  end
end
