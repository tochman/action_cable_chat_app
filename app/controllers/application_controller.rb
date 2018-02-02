class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include SessionsHelper

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
        @current_user = User.create!, {validate: false}
      end
    end
end
