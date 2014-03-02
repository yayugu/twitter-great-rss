require 'oauth'
require 'json'

class OAuthTwitter
  SITE_URL = 'https://api.twitter.com'

  def request_token(hash)
    self.consumer.get_request_token(hash)
  end

  def access_token(request_token, request_token_secret, oauth_token, oauth_verifier)
    request_token = OAuth::RequestToken.new(self.consumer, request_token, request_token_secret)
    request_token.get_access_token(
      {},
      :oauth_token => oauth_token,
      :oauth_verifier => oauth_verifier
    )
  end

  def consumer
    OAuth::Consumer.new(
      ENV['CONSUMER_KEY'],
      ENV['CONSUMER_SECRET'],
      site: SITE_URL
    )
  end

  def user_id(access_token)
    body = access_token.get("#{SITE_URL}/1.1/account/verify_credentials.json").body
    JSON.parse(body)['id_str']
  end
end
