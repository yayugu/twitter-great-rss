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
    @user = User.where(twitter_id: twitter_user_id).first_or_initialize
    @user.twitter_access_token = @access_token.token
    @user.twitter_access_secret= @access_token.secret
    @user.save!

    if @user
      session[:user_id] = @user.id
    end

    redirect_to root_url
  end

  def logout
    reset_session
    redirect_to root_url
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
