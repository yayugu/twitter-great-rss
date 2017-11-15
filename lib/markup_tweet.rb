class MarkupTweet
  class << self
    def markup_tweet(tweet)
      text = tweet['text']
      entities = tweet['entities']
      extended_entities = tweet['extended_entities']
      MarkupTweet::markup_media(text, entities, extended_entities)
      MarkupTweet::markup_urls(text, entities)
      MarkupTweet::markup_user_mentions(text, entities)
      MarkupTweet::markup_hashtags(text, entities)
      text
    end

    # see https://dev.twitter.com/docs/tweet-entities
    def markup_media(text, entities, extended_entities)
      en = extended_entities && extended_entities['media'] ? extended_entities : entities
      return text unless en['media']
      en['media'].each do |media|
        next unless media['type'] == 'photo'
        text.gsub!(media['url'], "<div><a href='#{media['media_url']}'><img src='#{media['media_url']}' /></a></div>")
      end
      text
    end

    def markup_urls(text, entities)
      entities['urls'].each do |url|
        new_url = url['expanded_url'] || url['url']
        text.gsub!(url['url'], "<a href='#{new_url}'>#{new_url}</a>")
      end
      text
    end

    def markup_user_mentions(text, entities)
      entities['user_mentions'].each do |mention|
        screen_name = mention['screen_name']
        text.gsub!("@#{screen_name}", "<a href='http://twitter.com/#{screen_name}'>@#{screen_name}</a>")
      end
      text
    end

    def markup_hashtags(text, entities)
      entities['hashtags'].each do |hashtag|
        hashtag_text = hashtag['text']
        text.gsub!(/[\#＃♯]#{Regexp.quote hashtag_text}/, "<a href='http://twitter.com/search?q=%23#{hashtag_text}'>##{hashtag_text}</a>")
      end
      text
    end
  end
end
