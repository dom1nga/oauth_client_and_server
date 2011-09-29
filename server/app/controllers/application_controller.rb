class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    user_signed_in?
  end

  def login_required
    authenticate_user!
    @user ||= current_user
    @access_token ||= OAuth::AccessToken.new(@client_application)
  end

end
