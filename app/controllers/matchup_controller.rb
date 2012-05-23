class Roster < ActiveResource::Base

  def initialize(access_token)
      self.access_token = access_token
      self.site = "http://api.cbssports.com/fantasy/league/rosters"
  end


end
class MatchupController < ApplicationController
  def index
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]

     roster = Roster.new(@acess_token)

     @players = roster.get(:access_token => @access_token, :response_format => 'json')

  end

  def help
  end
end
