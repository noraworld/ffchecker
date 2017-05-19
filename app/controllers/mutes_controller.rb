class MutesController < ApplicationController
  before_action :signed_in?

  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
  end

  def create
    username = params[:username]
    @@client.mute(username)
    render :nothing => true, :status => 200 and return
  end

  def destroy
    username = params[:username]
    @@client.unmute(username)
    render :nothing => true, :status => 200 and return
  end

  private
  def signed_in?
    unless current_user
      redirect_to '/signin'
    end
  end

end
