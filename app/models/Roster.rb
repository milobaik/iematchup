require 'httparty'

class Team
  include HTTParty
  base_uri 'http://api.cbssports.com/fantasy/league'
  format :json

  def initialize( query_params )
    @query_params = query_params
    puts @query_params
  end

  def self.get_resource(resource, query_params)
    get(resource, :query => query_params)
  end

  def self.put_resource( resource, body, query_params )
    response = put( resource, :body => { :payload => body, :access_token => query_params[:access_token],
                                        :league_id => query_params[:league_id], :response_format => "json" } )
    #puts response.body, response.code, response.message, response.headers.inspect
    return response
  end

  def teams
    @teams = Team.get_resource('/teams?version=2.0', @query_params)
    return @teams["body"]["teams"]
  end

  def roster
    @team = Team.get_resource('/rosters?version=2.0', @query_params)
    return @team["body"]["rosters"]["teams"]
  end

  def roster_for_team(team_id)
    @team = Team.get_resource("/rosters?version=2.0?team_id=#{team_id}", @query_params)
    return @team["body"]["rosters"]["teams"]
  end

  def players
    return @team["body"]["rosters"]["teams"][0]["players"]
  end

  def players_by_position( position )
    puts "Filter players for pos: #{position}"
    ids = []
    @team["body"]["rosters"]["teams"][0]["players"].each do |player|
      #puts "player: #{player["id"]} #{player["roster_pos"]}"
      if player["roster_pos"] == position && player["roster_status"] == "A"
        #puts "r: #{position} p: #{player["roster_pos"]} id: #{player["id"]}}"
        ids << player["id"]
      end
    end
    return ids
  end

  def bench_batters( )
    ids = []
    @team["body"]["rosters"]["teams"][0]["players"].each do |player|
      #puts "player: #{player["id"]} #{player["roster_pos"]}"
      if player["roster_pos"] != "P" && player["roster_status"] != "A"
        #puts "r: #{position} p: #{player["roster_pos"]} id: #{player["id"]}}"
        ids << player["id"]
      end
    end
    return ids
  end

  def bench_pitchers( )
    ids = []
    @team["body"]["rosters"]["teams"][0]["players"].each do |player|
      #puts "player: #{player["id"]} #{player["roster_pos"]}"
      if player["roster_pos"] == "P" && player["roster_status"] != "A"
        #puts "r: #{position} p: #{player["roster_pos"]} id: #{player["id"]}}"
        ids << player["id"]
      end
    end
    return ids
  end

  def set_lineup( roster_moves )
    puts "Set Lineup: #{roster_moves}"
    lineup_changes = roster_moves.to_json
    puts "#{lineup_changes}"
    puts @query_params
    resourceURL = "/transactions/lineup?version=2.0"
    resp = Team.put_resource( resourceURL, lineup_changes, @query_params)
    puts "Lineup Change has been PUT!"
    return resp
  end

end

