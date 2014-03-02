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
    "https://twitter.com/#{screen_name}/status/#{@hash['id']}"
  end

  def description
    " <img src='#{@hash['user']['profile_image_url']}' width='16px' height='16px' /> #{markupped_text} "
  end

  def created_at
    @hash['created_at']
  end

  def author
    @hash['source'].gsub(/<\/?[^>]*>/, "")
  end
end
