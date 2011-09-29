class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    user_signed_in?
  end

  def login_required
    if user_signed_in?
      @user ||= current_user
      @access_token ||= OAuth::AccessToken.new(@client_application)
    else
      authenticate_user!
      @user ||= current_user
      @access_token ||= OAuth::AccessToken.new(@client_application)
    end
  end

end
