class MatchupController < ApplicationController
  def index
    @access_token = params[:access_token]
  end

  def help
  end
end
