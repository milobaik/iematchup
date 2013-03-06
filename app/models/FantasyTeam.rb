require 'httparty'

class FantasyTeam
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

  def getFantasyTeam
    response = FantasyTeam.get_resource('/teams?version=2.0', @query_params)
    response["body"]["teams"].each do |team|
      if team["logged_in_team"]
        @fantasyTeam = team
        break
      end
    end
    puts "team: #{@fantasyTeam["name"]} id: #{@fantasyTeam["id"]} logged_in: #{@fantasyTeam["logged_in_team"]}"
    return @fantasyTeam
  end

  def getTeamId
    return @fantasyTeam["id"]
  end

  def getFantasyRoster
    response = FantasyTeam.get_resource('/rosters?version=2.0', @query_params)
    @roster = response["body"]["rosters"]["teams"][0]
    puts "Roster: point: #{@roster['point']} period: #{@roster['period']} **"
    return @roster
  end

  def roster_for_team(team_id)
    @team = FantasyTeam.get_resource("/rosters?version=2.0?team_id=#{team_id}", @query_params)
    return @team["body"]["rosters"]["teams"]
  end

  def players_by_position( position )
    #puts "Filter players for pos: #{position}"
    ids = []
    @roster["players"].each do |player|
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
    @roster["players"].each do |player|
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
    @roster["players"].each do |player|
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
    resp = FantasyTeam.put_resource( resourceURL, lineup_changes, @query_params)
    puts "Lineup Change has been PUT!"
    return resp
  end

end

