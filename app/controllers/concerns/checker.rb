module Checker
  extend ActiveSupport::Concern

  CONSUMER_KEY    = ENV['TWITTER_CONSUMER_KEY']
  CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']

  def check(request)
    credentials = Base64.encode64("#{CONSUMER_KEY}:#{CONSUMER_SECRET}").gsub("\n", "")

    post_url = 'https://api.twitter.com/oauth2/token'
    body     = 'grant_type=client_credentials'
    headers  = {
      "Authorization": "Basic #{credentials}",
      "Content-Type":  "application/x-www-form-urlencoded;charset=UTF-8"
    }
    req             = HTTParty.post(post_url, body: body, headers: headers)
    bearer_token    = JSON.parse(req.body)['access_token']
    api_auth_header = {"Authorization": "Bearer #{bearer_token}"}

    friends_url   = "https://api.twitter.com/1.1/friends/ids.json?screen_name=#{current_user.screen_name}"
    friends       = HTTParty.get(friends_url,   headers: api_auth_header).body
    friends       = JSON.parse(friends)
    followers_url = "https://api.twitter.com/1.1/followers/ids.json?screen_name=#{current_user.screen_name}"
    followers     = HTTParty.get(followers_url, headers: api_auth_header).body
    followers     = JSON.parse(followers)

    only_followings_or_followers = {}

    case request
    when 'followings'
      only_followings_or_followers[:ids] = friends['ids'] - followers['ids']
    when 'followers'
      only_followings_or_followers[:ids] = followers['ids'] - friends['ids']
    end

    only_followings_or_followers[:url] = "https://api.twitter.com/1.1/users/lookup.json?user_id="
    only_followings_or_followers[:data]

    if params[:num]
      count = (params[:num].to_i - 1) * 100
    else
      count = 0
    end

    users_num = only_followings_or_followers[:ids].count - count

    if users_num >= 100
      100.times do |i|
        only_followings_or_followers[:url] += only_followings_or_followers[:ids][count].to_s + ','
        count += 1
      end
    elsif users_num > 0 && users_num < 100
      users_num.times do |i|
        only_followings_or_followers[:url] += only_followings_or_followers[:ids][count].to_s + ','
        count += 1
      end
    else
      only_followings_or_followers = nil
      return only_followings_or_followers
    end

    only_followings_or_followers[:url].chop!
    only_followings_or_followers[:data] = HTTParty.post(only_followings_or_followers[:url], headers: api_auth_header).body
    only_followings_or_followers[:data] = JSON.parse(only_followings_or_followers[:data])
    only_followings_or_followers[:data].flatten!

    return only_followings_or_followers[:data]
  end

end
