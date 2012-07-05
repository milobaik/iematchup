class MatchupController < ApplicationController
 require 'Roster'
 require 'Matchups'
 require 'json'

 def index
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]
    #@access_token='U2FsdGVkX19XQBvvPM0GU2-WjND6ttc4kvYp51enbk6LSb6P9AUGeiBfZVB_Ur-sWGelICqIhXxCHxlINOc_BLeBRgmqu4EGrbPhYWJSwFSZv6dh1DfjbmjqnOKkbqp_'
    #@user_id='bc7626e28b25faa8''
    #@league_id='2342-roto'

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

      @team_roster[player["id"]] = { :name => player["fullname"],
                                  :id => player["id"],
                                  :profile_url => player["profile_url"],
                                  :roster_pos => player["roster_pos"],
                                  :roster_status => player["roster_status"],
                                  :mlb_pos => player["position"],
                                  :mlb_team => player["pro_team"],
                                  :eligible => player["eligible"].split(","),
                                  :opponent => mup[:opponent],
                                  :rating => mup[:rating],
                                  :analysis => mup[:analysis] }
    end

    player_disp_order = ["C", "1B", "2B", "3B", "SS", "CI", "MI", "OF", "U", "P"]

    @player_list = { :batters => [],
                     :bench_batters => [],
                     :pitchers => [],
                     :bench_pitchers => []
    }

    player_disp_order.each do |pos|
      ids = league.players_by_position( pos )
      if ids.empty?
        puts "No batters for positon #{pos}"
      else
        puts "#{ids.length} players eligile for pos: #{pos} #{ids}"
        ids.each do |id|
          puts "pos: #{pos} id: #{id} player: #{@team_roster[id]}"
          if ( pos == "P" )
            player_type = ( @team_roster[id][:roster_status] =~ /A/ ) ? :pitchers : :bench_pitchers
          else
            player_type = ( @team_roster[id][:roster_status] =~ /A/ ) ? :batters : :bench_batters
          end
          @team_roster[id][:section] = player_type
          @team_roster[id][:idx] = @player_list[player_type].length
          @player_list[player_type] << @team_roster[id]

        end
      end
    end

  @team_roster_json = @team_roster.to_json
  @player_list_json = @player_list.to_json
 end

 def team_matchup
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]
    #@access_token='U2FsdGVkX19XQBvvPM0GU2-WjND6ttc4kvYp51enbk6LSb6P9AUGeiBfZVB_Ur-sWGelICqIhXxCHxlINOc_BLeBRgmqu4EGrbPhYWJSwFSZv6dh1DfjbmjqnOKkbqp_'
    #@user_id='bc7626e28b25faa8''
    #@league_id='2342-roto'

    league = Team.new( :access_token => @access_token, :response_format => 'json' )

    @teams = league.teams
    @roster = league.roster_for_team(params[:team_id])
    @players = league.players

    mups = Matchups.new()
    @matchups = mups.get_matchups

    @player_list = {}
    @players.each do |player|

      mup = @matchups[player["fullname"]]
      if mup != nil
        puts "player name #{player["fullname"]} position: #{player["roster_pos"]}"
        @player_list["#{player['roster_pos']}"] = {:position => player["roster_pos"],
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
