class ListsController < ApplicationController
  before_action :signed_in?

  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end

  def index
    @lists = @@client.lists()
  end

  def show
    @members = @@client.list_members(params[:listname])
    muted_users = @@client.muted({:skip_status => true})
    @muted_user_list = []
    muted_users.each do |muted_user|
      @muted_user_list.push(muted_user.screen_name)
    end
  end

  private
  def signed_in?
    unless current_user
      redirect_to '/signin'
    end
  end

end
