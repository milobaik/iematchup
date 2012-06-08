class MatchupController < ApplicationController
 require 'Roster'
 require 'Matchups'

 def index
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]
    #@access_token='U2FsdGVkX19XQBvvPM0GU2-WjND6ttc4kvYp51enbk6LSb6P9AUGeiBfZVB_Ur-sWGelICqIhXxCHxlINOc_BLeBRgmqu4EGrbPhYWJSwFSZv6dh1DfjbmjqnOKkbqp_'
    #@user_id='bc7626e28b25faa8''
    #@league_id='2342-roto'

     team = Team.new()

     @roster = team.roster({ :access_token => @access_token, :format => 'json'})
     @players = team.players

      mups = Matchups.new()
      @matchups = mups.get_matchups

      @players.each do |player|
        puts "player name #{player["fullname"]}"
        mup = @matchups[player["fullname"]]
        if mup != nil
          player["opponent"] = mup[:opponent]
          player["rating"] = mup[:rating]
          player["analysis"] = mup[:analysis]
        else
          puts "player: #{player["fullname"]} not in matchup file."
        end
      end
  end

  def help
  end
end
