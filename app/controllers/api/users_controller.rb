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
    CommunityData.init()
    #data = CommunityData.community_info
    creator_types = params[:creator_type]
    creators = CommunityData.community_info
    if creator_types
      creators = []
      creator_types = creator_types.split(",")
      CommunityData.community_info.each do |creator|
        intersect = creator['creator_types'] & creator_types
        if intersect.sort == creator_types.sort
          creators << creator
        end
      end
    end

    render json: creators.sort {|a, b| b["reach"] <=> a['reach'] }
  end

  def feed
    user_id = params[:user_id]
    profile_data = CommunityData.profiles[user_id]
    render json: {user_id: profile_data}
  end 


end