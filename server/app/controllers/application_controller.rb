class ApplicationController < ActionController::Base
  protect_from_forgery

  def logged_in?
    user_signed_in?
  end

end
