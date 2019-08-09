module Entity
  module V1
    class Following < Grape::Entity
      expose :user_id
      expose :followed_user_id
    end
  end
end
