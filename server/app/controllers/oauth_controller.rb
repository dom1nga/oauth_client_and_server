require 'oauth/controllers/provider_controller'
class OauthController < ApplicationController
  include OAuth::Controllers::ProviderController

  def authorize
    if params[:oauth_token]
      @token = ::RequestToken.find_by_token! params[:oauth_token]
      oauth1_authorize
    elsif ["code","token"].include?(params[:response_type]) # pick flow
      send "oauth2_authorize_#{params[:response_type]}"
    else
      render :status=>404, :text=>"No token provided"
    end
  end

  def oauth1_authorize
    unless @token
      render :action=>"authorize_failure"
      return
    end

    unless @token.invalidated?
      if Rails.application.config.disable_oauth_authorize_access_page
        oauth1_authorize_actions
      else
        if request.post?
          if user_authorizes_token?
            oauth1_authorize_actions
          else
            @token.invalidate!
            render :action => "authorize_failure"
          end
        end
      end
    else
      render :action => "authorize_failure"
    end
  end

  def oauth1_authorize_actions
    @token.authorize!(current_user)
    @redirect_url = URI.parse(@token.oob? ? @token.client_application.callback_url : @token.callback_url)

    unless @redirect_url.to_s.blank?
      @redirect_url.query = @redirect_url.query.blank? ?
                            "oauth_token=#{@token.token}&oauth_verifier=#{@token.verifier}" :
                            @redirect_url.query + "&oauth_token=#{@token.token}&oauth_verifier=#{@token.verifier}"
      redirect_to @redirect_url.to_s
    else
      render :action => "authorize_success"
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
