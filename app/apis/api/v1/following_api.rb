module API
  module V1
    class FollowingAPI < Grape::API
      resource :followings do
        before { authenticate_user! }

        desc 'Follow other user' do
          success Entity::V1::Following
        end
        params do
          requires :followed_user_id, type: Integer
        end
        post do
          followed_user = User.find_by(id: params[:followed_user_id])
          error!('Followed user doesn\'t exist.', 400) unless followed_user

          following = Following.find_by(user: current_user, followed_user: followed_user)
          unless following
            following = Following.new(user: current_user, followed_user: followed_user)
            error!(following.errors.full_messages, 400) unless following.save
          end

          present following, with: Entity::V1::Following
        end

        desc 'Unfollow other user'
        params do
          requires :followed_user_id, type: Integer
        end
        delete do
          following = Following.find_by(
            user_id: current_user.id,
            followed_user_id: params[:followed_user_id]
          )
          following.destroy if following

          status 204
        end
      end
    end
  end
end
