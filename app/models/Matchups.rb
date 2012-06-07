require 'csv'

class Matchups

    def initialize
          csv.foreach('IEMatFOR2012-06-10UPDATED2012-06-03.csv'), :headers => :first_row) { |row|
          player_name = "#{row['first_name']} #{row['last_name']}"
          opp_name = "#{row['opp_first_name']} #{row['opp_last_name']}"
          @players[player_name] = { :opponent => opp_name, :rating => row['matchup_rating'],
                                    :analysis => row['analysis']}
    end

    def get_player( player_name )
      return @players[player_name]
    end
end

