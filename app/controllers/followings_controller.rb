class FollowingsController < ApplicationController
  before_action :signed_in?

  CONSUMER_KEY    = ENV['TWITTER_CONSUMER_KEY']
  CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']

  def index
    credentials = Base64.encode64("#{CONSUMER_KEY}:#{CONSUMER_SECRET}").gsub("\n", "")

    post_url    = 'https://api.twitter.com/oauth2/token'
    body        = 'grant_type=client_credentials'
    headers     = {
      "Authorization": "Basic #{credentials}",
      "Content-Type":  "application/x-www-form-urlencoded;charset=UTF-8"
    }
    req             = HTTParty.post(post_url, body: body, headers: headers)
    bearer_token    = JSON.parse(req.body)['access_token']
    api_auth_header = {"Authorization": "Bearer #{bearer_token}"}

    friends_url   = "https://api.twitter.com/1.1/friends/ids.json?screen_name=#{current_user.screen_name}"
    friends      = HTTParty.get(friends_url,   headers: api_auth_header).body
    friends      = JSON.parse(friends)
    followers_url = "https://api.twitter.com/1.1/followers/ids.json?screen_name=#{current_user.screen_name}"
    followers    = HTTParty.get(followers_url, headers: api_auth_header).body
    followers    = JSON.parse(followers)

    only_followings = {}
    only_followings[:ids] = friends['ids'] - followers['ids']
    only_followings[:url] = "https://api.twitter.com/1.1/users/lookup.json?user_id="
    only_followings[:data]
    count = (params[:num].to_i - 1) * 100

    if only_followings[:ids].count - count >= 100
      100.times do |i|
        only_followings[:url] += only_followings[:ids][count].to_s + ','
        count += 1
      end
    else
      (only_followings[:ids].count - count).times do |i|
        only_followings[:url] += only_followings[:ids][count].to_s + ','
        count += 1
      end
    end

    only_followings[:url].chop!
    only_followings[:data] = HTTParty.post(only_followings[:url], headers: api_auth_header).body
    only_followings[:data] = JSON.parse(only_followings[:data])
    only_followings[:data].flatten!

    @users = only_followings[:data]
  end

  private
  def signed_in?
    unless current_user
      redirect_to '/signin'
    end
  end

end
