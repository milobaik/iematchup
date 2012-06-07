require 'httparty'

class Team
  include HTTParty
  base_uri 'http://api.cbssports.com/fantasy/league'
  format :json


  def self.get_roster( query_params )
    get('/rosters', :query => {:access_token => query_params[:access_token],
                                :response_format => query_params[:format]}  )
  end

  def roster( query_params )
    team = Team.get_roster( query_params )
    return team["body"]["rosters"]["teams"]
  end
end

