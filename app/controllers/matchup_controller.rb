class MatchupController < ApplicationController
 require 'Roster'
 require 'Matchups'
 require 'json'

 def add_player_to_roster_map( pos, player_type, player, roster_map )
   cidx = roster_map[:index].length
   player_cb = { :empty => player.nil?,
                 :modified => "",
                 :idx => cidx,
                 :section => player_type,
                 :sidx => roster_map[player_type].length,
                 :position => pos,
                 :player => player }
   roster_map[player_type] << player_cb
   roster_map[:index] << player_cb
 end

def index
  @access_token = params[:access_token]
  @user_id = params[:user_id]
  @league_id = params[:league_id]

  league = Team.new( :access_token => @access_token, :response_format => 'json' )

  @teams = league.teams
  @roster = league.roster
  @players = league.players

  mups = Matchups.new()
  @matchups = mups.get_matchups

  @team_roster = {}
  @players.each do |player|
    mup = @matchups[player["fullname"]]
    if mup == nil
      puts "player: #{player["fullname"]} not in matchup file."
      mup = { :opponent => "Unknown",
              :rating => 0,
              :analysis => "None"
      }
    end

    @team_roster[player["id"]] = {:name => player["fullname"],
                                  :id => player["id"],
                                  :profile_url => player["profile_url"],
                                  :roster_pos => player["roster_pos"],
                                  :roster_status => player["roster_status"],
                                  :mlb_pos => player["position"],
                                  :mlb_team => player["pro_team"],
                                  :eligible => player["eligible"].split(","),
                                  :opponent => mup[:opponent],
                                  :rating => "*" * mup[:rating],
                                  :analysis => mup[:analysis] }
  end

  player_disp_order = ["C", "1B", "2B", "3B", "SS", "CI", "MI", "OF", "U" ]

  @roster_display_map = { :index => [],
                          :batters => [ ],
                          :bench_batters => [ ],
                          :pitchers => [],
                          :bench_pitchers => []
  }

  # fill in the active batters
  player_type = :batters
  player_disp_order.each do |pos|
    ids = league.players_by_position( pos )
    if ids.empty?
      puts "No batters for positon #{pos}"
      # no player assigned to this position, add "nil" player to the roster map
      num_missing = ( pos == "OF" ) ? 5 : 1
      ids.length.upto(num_missing) do
        add_player_to_roster_map( pos, player_type, nil, @roster_display_map )
      end
    else
      puts "#{ids.length} players eligile for pos: #{pos} #{ids}"
      ids.each do |id|
        puts "pos: #{pos} id: #{id} player: #{@team_roster[id]}"
        add_player_to_roster_map( pos, player_type, @team_roster[id], @roster_display_map )
      end
      if pos == "OF" && ids.length < 5
        # fill in missing outfielder slots in active list with "nil" player
        ids.length.upto(5) do
          add_player_to_roster_map( pos, player_type, nil, @roster_display_map )
        end
      end
    end
  end

  # fill in bench batters
  player_type = :bench_batters
  pos = "Bench"
  ids = league.bench_batters
  ids.each do |id|
    puts "id: #{id} player: #{@team_roster[id]}"
    add_player_to_roster_map( pos, player_type, @team_roster[id], @roster_display_map )
  end

  # fill in missing bench slots with "nil" player
  if ids.length < 5
    ids.length.upto(5) do
      add_player_to_roster_map( pos, player_type, nil, @roster_display_map )
    end
  end

  # fill in pitchers
  player_type = :pitchers
  pos = "P"
  ids = league.players_by_position( pos )
  puts "#{ids.length} players eligile for pos: #{pos} #{ids}"
  ids.each do |id|
    puts "id: #{id} player: #{@team_roster[id]}"
    add_player_to_roster_map( pos, player_type, @team_roster[id], @roster_display_map )
  end

  # fill in missing pitchers with nil player
  if ids.length < 9
    ids.length.upto(9) do
      add_player_to_roster_map( pos, player_type, nil, @roster_display_map )
    end
  end

  # fill in bench pitchers
  player_type = :bench_pitchers
  ids = league.bench_pitchers
  ids.each do |id|
    puts "id: #{id} player: #{@team_roster[id]}"
    add_player_to_roster_map( pos, player_type, @team_roster[id], @roster_display_map )
  end

  if ids.empty?
    # fill in missing bench slots with empty player
    add_player_to_roster_map( pos, player_type, nil, @roster_display_map )
  end

  @team_roster_json = @team_roster.to_json
  @player_list_json = @roster_display_map.to_json
 end

 def team_matchup
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]

    league = Team.new( :access_token => @access_token, :response_format => 'json' )

    @teams = league.teams
    @roster = league.roster_for_team(params[:team_id])
    @players = league.players

    mups = Matchups.new()
    @matchups = mups.get_matchups

    @roster_display_map = {}
    @players.each do |player|

      mup = @matchups[player["fullname"]]
      if mup != nil
        puts "player name #{player["fullname"]} position: #{player["roster_pos"]}"
        @roster_display_map["#{player['roster_pos']}"] = {:position => player["roster_pos"],
                                                   :name => player["fullname"],
                                                   :id => player["id"],
                                                   :opponent => mup[:opponent],
                                                   :rating => mup[:rating],
                                                   :analysis => mup[:analysis] }
        player["opponent"] = mup[:opponent]
        player["rating"] = mup[:rating]
        player["analysis"] = mup[:analysis]
      else
        puts "player: #{player["fullname"]} not in matchup file."
        player["opponent"] = "None"
        player["rating"] = 0
        player["analysis"] = "None"
      end
    end
  end

  def help
  end

  def raw
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]

    team = Team.new(:access_token => @access_token, :response_format => 'json')

    @roster = team.roster
    @players = team.players

  end
end
