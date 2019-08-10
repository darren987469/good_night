module API
  module V1
    class BaseAPI < Grape::API
      mount FollowingAPI
      mount SleepAPI
    end
  end
end
