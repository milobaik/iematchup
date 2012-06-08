class MatchupController < ApplicationController
 require 'Roster'
 require 'Matchups'

 def index
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]

     team = Team.new()

     @roster = team.roster({ :access_token => @access_token, :format => 'json'})
     @players = team.players

      mups = Matchups.new()
      @matchups = mups.get_matchups
  end

  def help
  end
end
