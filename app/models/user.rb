require 'digest/sha1'

class User < ActiveRecord::Base
  before_create do
    self.url_id_hash = Digest::SHA1.hexdigest(rand().to_s + self.twitter_id)
  end
end
