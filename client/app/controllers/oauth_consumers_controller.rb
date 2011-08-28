require 'oauth/controllers/consumer_controller'
class OauthConsumersController < ApplicationController
  include Oauth::Controllers::ConsumerController
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

  def current_user=(user)
    sign_in(user)
  end

end
