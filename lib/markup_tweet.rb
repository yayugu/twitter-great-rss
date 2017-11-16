class MarkupTweet
  class << self
    def markup_tweet(tweet)
      text = tweet['text']
      entities = tweet['entities']
      extended_entities = tweet['extended_entities']
      text = MarkupTweet::markup_media(text, entities, extended_entities)
      text = MarkupTweet::markup_urls(text, entities)
      text = MarkupTweet::markup_user_mentions(text, entities)
      text = MarkupTweet::markup_hashtags(text, entities)
      text = MarkupTweet::markup_quote(text, tweet)
      text = MarkupTweet::markup_author(text, tweet)
      text
    end

    # see https://dev.twitter.com/docs/tweet-entities
    def markup_media(text, entities, extended_entities)
      en = extended_entities && extended_entities['media'] ? extended_entities : entities
      return text unless en['media']
      en['media'].each do |media|
        next unless media['type'] == 'photo'
        text.gsub!(media['url'], '')
        text << "<div><a href='#{media['expanded_url']}'><img src='#{media['media_url']}' /></a></div>"
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

    def markup_quote(text, tweet)
      return text unless tweet['quoted_status']
      quoted_status = tweet['quoted_status']
      text.gsub("https://twitter.com/#{quoted_status['user']['screen_name']}/status/#{quoted_status['id_str']}", '')
      "#{text}<blockquote>#{MarkupTweet::markup_author(quoted_status['text'], quoted_status)}</blockquote>"
    end

    def markup_author(text, tweet)
      " <img src='#{tweet['user']['profile_image_url']}' width='16px' height='16px' /> #{text} "
    end
  end
end
