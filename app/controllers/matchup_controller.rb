class MatchupController < ApplicationController
  def index
    @access_token = params[:access_token]
    @user_id = params[:user_id]
    @league_id = params[:league_id]
  end

  def help
  end
end
