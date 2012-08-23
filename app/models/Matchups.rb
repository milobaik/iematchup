require 'csv'


class Matchups

    def initialize
        @mups = Hash.new()
        iemup_file = 'app/models/IEMatFOR2012-08-20UPDATED2012-08-19.csv'

          CSV.foreach(iemup_file, :headers => :first_row) { |row|
            player_name = "#{row[4]} #{row[5]}"
            opp_name = "#{row[7]} #{row[8]}"
            matchup = {:player => player_name, :opponent => opp_name, :rating => row[10].to_i, :analysis => row[11]}
            @mups[player_name] = matchup
          }
    end

    def get_matchups
      return @mups
    end

    def get_player( player_name )
      return @mups[player_name]
    end
end

