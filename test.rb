
# For simple irb testing
def metar(location, user)
    require 'net/http'
    require "json"

    if !location.nil?
        resp = Net::HTTP.get(URI("http://avwx.rest/api/metar/#{location.upcase}"))
        j_resp = JSON.parse(resp)
        if !j_resp.nil?
            if !j_resp["Error"].nil?
                return "@#{user} METAR is confused. Error was: #{j_resp["Error"]}."
            else
                if j_resp["Raw-Report"]
                    return "@#{user} METAR raw report: #{j_resp["Raw-Report"]}."
                end
            end    
        else
            return "@#{user} METAR is lost. Example to use: [METAR CYVR]."
        end
    end
end

def taf(location, user)
    require 'net/http'
    require "json"

    if !location.nil?
        resp = Net::HTTP.get(URI("http://avwx.rest/api/taf/#{location.upcase}"))
        j_resp = JSON.parse(resp)
        if !j_resp.nil?
            if !j_resp["Error"].nil?
                return "@#{user} TAF is confused. Error was: #{j_resp["Error"]}."
            else
                if j_resp["Raw-Report"]
                    return "@#{user} TAF raw report: #{j_resp["Raw-Report"]}."
                end
            end    
        else
            return "@#{user} TAF is lost. Example to use: [TAF CYVR]."
        end
    end
end

puts metar("CYVR", "fearlessfrog")

puts taf("KJFK", "fearlessfrog")