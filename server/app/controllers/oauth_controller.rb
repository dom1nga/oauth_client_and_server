require 'oauth/controllers/provider_controller'
class OauthController < ApplicationController
  include OAuth::Controllers::ProviderController

  def authorize
    if params[:oauth_token]
      @token = ::RequestToken.find_by_token! params[:oauth_token]
      @token.authorize!(current_user)
      @redirect_url = URI.parse(@token.oob? ? @token.client_application.callback_url : @token.callback_url)
      @redirect_url.query = @redirect_url.query.blank? ?
                              "oauth_token=#{@token.token}&oauth_verifier=#{@token.verifier}" :
      @redirect_url.query + "&oauth_token=#{@token.token}&oauth_verifier=#{@token.verifier}"
      redirect_to @redirect_url.to_s
    elsif ["code","token"].include?(params[:response_type]) # pick flow
      send "oauth2_authorize_#{params[:response_type]}"
    else
      render :status=>404, :text=>"No token provided"
    end
  end

  protected

  def authenticate_user(username,password)
    user = User.find_by_email params[:username]
    if user && user.valid_password?(params[:password])
      user
    else
      nil
    end
  end

end
