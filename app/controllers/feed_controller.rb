class FeedController < ApplicationController
  TWEET_COUNT = 200

  before_action :prepare_twitter_client

  def user
    res = @client.user(params[:name], TWEET_COUNT)
    render_error and return if res.error

    @image_url = res.body.first['user']['profile_image_url']
    @name = res.body.first['user']['screen_name']
    @tweets = Tweet.tweets_from_hash_list(res.body)
    render_rss
  end

  def list
    res = @client.list(params[:name], params[:slug], TWEET_COUNT)
    render_error and return if res.error

    @name = params[:name]
    @slug = params[:slug]
    @tweets = Tweet.tweets_from_hash_list(res.body)
    render_rss
  end

  def search
    res = @client.search(params[:q], TWEET_COUNT)
    render_error and return if res.error

    @query = params[:q]
    @tweets = Tweet.tweets_from_hash_list(res.body)
    render_rss
  end

  private

  def user_for_api_token
    url_id_hash = params[:url_id_hash]
    url_id_hash && (@user = User.where(url_id_hash: url_id_hash).first)
  end

  def prepare_twitter_client
    user = user_for_api_token
    unless user
      render :file => "public/404.html", :status => :unauthorized
      return
    end
    @client = TwitterClient.new(user.twitter_access_token, user.twitter_access_secret)
  end

  def render_rss
    render layout: false, content_type: 'application/rss+xml'
  end

  def render_error
    render :file => "public/500.html", :status => 500
  end
end
