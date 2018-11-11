# Require
* Ruby 2.5.3

# Setup locally
1. Access `https://apps.twitter.com/` in browser.
2. Create new app.
3. Set Application Details and set `http://localhost:3000/auth/callback` to Callback URLs.
4. Open terminal.
5. `gem install bundler`
6. `git clone http://github.com/yayugu/twitter-great-rss`
7. `cd twitter-great-rss`
8. `cp config/database.yml{.sample,}`
8. `cp .env{.sample,}`
9. Edit `.env` and set `CONSUMER_KEY` and `CONSUMER_SECRET` for Twitter.
10. `bundle install`
11. `bin/rails db:migrate`
12. `bin/rails s`
13. Access `localhost:3000` in browser.
