TwitterGreatRss::Application.routes.draw do
  root 'main#index'

  scope :auth do
    get 'auth' => 'auth#auth'
    get 'callback' => 'auth#callback'
    get 'logout' => 'auth#logout'
  end

  scope :feed do
    get 'home' => 'feed#home'
    get 'user' => 'feed#user'
    get 'user/fav' => 'feed#user_fav'
    get 'list' => 'feed#list'
    get 'search' => 'feed#search'
  end
end
