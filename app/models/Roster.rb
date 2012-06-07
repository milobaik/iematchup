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
    Team.get_roster( query_params )["body"]["rosters"]["teams"]["players"]
  end
end

