require 'oauth/controllers/consumer_controller'
class OauthConsumersController < ApplicationController
  include Oauth::Controllers::ConsumerController
  #before_filter :authenticate_user!, :only=>:index
  before_filter :login_or_oauth_required, :only=>:index

  def index
    @consumer_tokens=ConsumerToken.all :conditions=>{:user_id=>current_user.id}
    @services=OAUTH_CREDENTIALS.keys-@consumer_tokens.collect{|c| c.class.service_name}
  end

  def callback
    super
  end

  def client
    super
  end

  protected

  def go_back
    redirect_to root_url
  end

  def logged_in?
    user_signed_in?
  end

  # The plugin requires current_user to return the current logged in user. Uncomment and
  # call your auth frameworks equivalent below if different.
  # def current_user
  #   current_person
  # end

  # The plugin requires a way to log a user in. Call your auth frameworks equivalent below 
  # if different. eg. for devise:
  #
  def current_user=(user)
    sign_in(user)
  end

  # Override this to deny the user or redirect to a login screen depending on your framework and app
  # if different. eg. for devise:
  #
  # def deny_access!
  #   raise Acl9::AccessDenied
  # end
end
