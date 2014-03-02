class MainController < ApplicationController
  before_action :set_user

  def index
  end

  private

  def set_user
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
  end
end
