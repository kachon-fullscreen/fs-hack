require 'json'

class Api::UsersController < ApplicationController
  
  def show
    render json: {data: "hello"}
  end

  def index
    options = {
      headers: { 'Content-Type' => 'application/json' }
    }

    options[:headers]['Access-Key'] = ::AccessInfo.fs_key

    url = "https://jazz.fullscreen.net/api/channels/current_partners" 

    response = HTTParty.get(url, options)

    render json: response
  end

  def yt_info
    youtube_api = ::AccessInfo.youtube_key
    req = "https://www.googleapis.com/youtube/v3/search?key=#{youtube_api}&part=snippet&channelId=5Df0C7lSEuTipEKbxr7IUQ"
    render json: HTTParty.get(req)
  end

  def community_info
    data = JSON.parse(File.read("#{Rails.root}/config/community.json"))
    render json: data.sort {|a, b| b["reach"] <=> a['reach'] }
  end

  def feed
    user_id = params[:user_id]
    data = JSON.parse(File.read("#{Rails.root}/config/profile.json"))
    render json: {user_id: data[user_id]}
  end 


end