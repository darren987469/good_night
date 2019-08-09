module Helper
  module Base
    def authenticate_user!
      current_user || (raise NotAuthenticatedError)
    end

    def current_user
      # TODO: use devise to authenticate user, mock for now.
      @current_user ||= User.first
    end
  end
end
