class CommunityData

  class << self
    attr_accessor :community_info, :profiles, :done_init

    def init
      if done_init.nil?
        puts "start init"
        #data = JSON.parse(File.read("#{Rails.root}/config/community.json"))
        @community_info = []
        @profiles = {}
        (0..10).each do |index| 
          #puts "#{index}"
          url = "https://communityapi.fullscreen.net/api/v1/search/users?creator_types=musician,gamer&limit=20&offset=#{index*20}&order=relevance&min_reach=500"
          #puts "#{url}"
          cookie = {_accounts_session: ENV['SID']}
          users = HTTParty.get(url, cookies: cookie)
          users.each do |user|
            if !user['facebook'].nil?
              puts "fb #{user['facebook']}"
              slug = user['slug']
              profile_url = "https://communityapi.fullscreen.net/api/v1/user/#{slug}/activities/profiles/"
              profile_data = HTTParty.get(profile_url, cookies: cookie)
              if !profile_data.body.empty?
                reputation = {'reputation' => Random.rand(1..5)}
                @community_info << user.merge(reputation)
                @profiles[slug] = profile_data
              end
            end
          end
        end
        self.done_init = 'init already'
      end
      puts "stop done_init #{done_init} #{community_info.count}"
    end

  end

end