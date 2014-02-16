require 'oauth_twitter'

class AuthController < ApplicationController
  def auth
    token = request_token
    session[:request_token] = token.token
    session[:request_token_secret] = token.secret
    redirect_to token.authorize_url
  end

  def callback
    @access_token = nil
    begin
      @access_token = oauth_twitter.access_token(
        session[:request_token],
        session[:request_token_secret],
        params[:oauth_token],
        params[:oauth_verifier],
      )
    rescue OAuth::Unauthorized => @exception
      render inline: %{oauth failed: <%=h @exception.message %>}
      return
    end

    twitter_user_id = oauth_twitter.user_id(@access_token)

    @user = User.where(twitter_id: twitter_user_id).first

    unless @user
      @user = User.create!(
        twitter_id: twitter_user_id,
        twitter_access_token: @access_token.token,
        twitter_access_secret: @access_token.secret,
      )
    end

    #bookmarklet = URI.encode "javascript:void(function(){location.href = '#{base_url}/#{@id}' + location.pathname;})();"
  end

  private

  def oauth_twitter
    OAuthTwitter.new
  end

  def request_token
    callback_url = url_for controller: self.controller_name, action: 'callback', only_path: false
    oauth_twitter.request_token(:oauth_callback => callback_url)
  end
end
