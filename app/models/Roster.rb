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

  def teams
    @teams = Team.get_resource('/teams', @query_params)
    return @teams["body"]["teams"]
  end

  def roster
    @team = Team.get_resource('/rosters', @query_params)
    return @team["body"]["rosters"]["teams"]
  end

  def roster_for_team(team_id)
    @team = Team.get_resource("/rosters?team_id=#{team_id}", @query_params)
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
      if player["roster_pos"] == position
        #puts "r: #{position} p: #{player["roster_pos"]} id: #{player["id"]}}"
        ids << player["id"]
      end
    end
    return ids
  end
end

