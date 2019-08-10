module API
  module V1
    class BaseAPI < Grape::API
      mount FeedAPI
      mount FollowingAPI
      mount SleepAPI
    end
  end
end
