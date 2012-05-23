class MatchupController < ApplicationController
 require 'Roster'

  def index
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]

     team = Team.new()

     @players = team.roster({ :access_token => @access_token, :format => 'json'})

  end

  def help
  end
end
