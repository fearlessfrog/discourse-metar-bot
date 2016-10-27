# name: discourse-metar-bot
# about: returns the weather from avwx.rest METAR data
# version: 1
# authors: fearlessfrog
# url: https://github.com/fearlessfrog/discourse-metar-bot

after_initialize do

   def metar(location, user)
        require 'net/http'
        require "json"

        match = location.match(/\[ *METAR (\w*) *\]/i)
        loc = match[1] if match.present? 

        if loc.present?
            resp = Net::HTTP.get(URI("http://avwx.rest/api/metar/#{loc.upcase}"))
            j_resp = JSON.parse(resp)
            if !j_resp.nil?
                if !j_resp["Error"].nil?
                    return "@#{user.username} METAR is confused. Error was: #{j_resp["Error"]}."
                else
                    if j_resp["Raw-Report"]
                        return "@#{user.username} METAR raw report: #{j_resp["Raw-Report"]}."
                    end
                end    
            else
                return "@#{user.username} METAR is lost. Example to use: [METAR CYVR]."
            end
        else
            return "@#{user.username} METAR is lost. Example to use: [METAR CYVR]."
        end
    end

    def taf(location, user)
        require 'net/http'
        require "json"

        match = location.match(/\[ *TAF (\w*) *\]/i)
        loc = match[1] if match.present? 

        if loc.present?
            resp = Net::HTTP.get(URI("http://avwx.rest/api/taf/#{loc.upcase}"))
            j_resp = JSON.parse(resp)
            if !j_resp.nil?
                if !j_resp["Error"].nil?
                    return "@#{user.username} TAF is confused. Error was: #{j_resp["Error"]}."
                else
                    if j_resp["Raw-Report"]
                        return "@#{user.username} TAF raw report: #{j_resp["Raw-Report"]}."
                    end
                end    
            else
                return "@#{user.username} TAF is lost. Example to use: [TAF CYVR]."
            end
        else
            return "@#{user.username} TAF is lost. Example to use: [TAF CYVR]."
        end
    end

    def inline_metar(post)
        post.raw.gsub!(/\[ *METAR \w* *\]/i) { |loc| metar(loc, post.user) }
        
        # Hardcoded to metarbot user, nice..
        post.set_owner(User.find(494), post.user)
        
        #post.set_owner(User.find(-1), post.user)
    end

    def inline_taf(post)
        post.raw.gsub!(/\[ *TAF \w* *\]/i) { |loc| taf(loc, post.user) }
        
        # Hardcoded to metarbot user, nice..
        post.set_owner(User.find(494), post.user)
        
        #post.set_owner(User.find(-1), post.user)
    end

    on(:post_created) do |post, params|
    
        if SiteSetting.metar_bot_enabled
            if post.raw =~ /\[ *METAR \w* *\]/i
                inline_metar(post)
                post.save            
            end

            if post.raw =~ /\[ *TAF \w* *\]/i
                inline_taf(post)
                post.save            
            end
        end
    end
end
