class FollowersController < ApplicationController
  before_action :signed_in?
  include Checker

  def index
    @users = check('followers')
  end

  private
  def signed_in?
    unless current_user
      redirect_to '/signin'
    end
  end

end
