require 'httparty'

class Team
  include HTTParty
  base_uri 'http://api.cbssports.com/fantasy/league'
  format :json


  def self.get_roster( query_params )
    @team = get('/rosters', :query => {:access_token => query_params[:access_token],
                                  :response_format => query_params[:format]}  )
  end

  def roster( query_params )
    Team.get_roster( query_params )
    return @team["body"]["rosters"]["teams"].first
  end

  def players
    return @team["body"]["rosters"]["teams"].first["players"]
  end
end

