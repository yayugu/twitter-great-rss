require 'oauth'
require 'oauth_twitter'
require 'uri'

class TwitterClient
  def initialize(access_token, access_secret)
    @access_token = OAuth::AccessToken.new(OAuthTwitter.new.consumer, access_token, access_secret)
  end

  def user(name, count)
    get_and_json_parse(user_sub_url(name, count))
  end

  def list(name, slug, count)
    get_and_json_parse(list_sub_url(name, slug, count))
  end

  def search(query, count)
    response = get_and_json_parse(search_sub_url(query, count))
    response.body = response.body['statuses']
    response
  end

  private

  def user_sub_url(name, count)
    "/statuses/user_timeline.json?screen_name=#{name}&include_entities=true&count=#{count}&include_rts=true"
  end

  def list_sub_url(name, slug, count)
    "/lists/statuses.json?slug=#{slug}&owner_screen_name=#{name}&include_entities=true&count=#{count}&include_rts=true"
  end

  def search_sub_url(query, count)
    "/search/tweets.json?q=#{URI::encode_www_form_component(query)}&include_entities=true&count=#{count}"
  end

  def get_and_json_parse(sub_url)
    # Net::HTTPResponse
    response = @access_token.get(api_url(sub_url))
    body = JSON.parse(response.body)
    TwitterAPIResponse.new(body, response.value)
  end

  def api_url(sub_url)
    "#{OAuthTwitter::SITE_URL}/1.1/#{sub_url}"
  end
end
