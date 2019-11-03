class Tweet
  class << self
    def tweets_from_hash_list(hash_list)
      hash_list.map{|tweet_hash| Tweet.new(tweet_hash) }
    end
  end

  def initialize(tweet_hash)
    @hash = tweet_hash
    Rails.logger.debug @hash
  end

  def markupped_text
    MarkupTweet::markup_tweet(@hash)
  end

  def screen_name
    @hash['user']['screen_name']
  end

  def url
    status = retweeted_status || @hash
    "https://twitter.com/#{status['user']['screen_name']}/status/#{status['id']}"
  end

  def description
    markupped_text
  end

  def created_at
    @hash['created_at']
  end

  def author
    @hash['source'].gsub(/<\/?[^>]*>/, "")
  end

  def retweeted_status
    @hash['retweeted_status']
  end
end
