module API
  module V1
    class BaseAPI < Grape::API
      mount FollowingAPI
    end
  end
end
