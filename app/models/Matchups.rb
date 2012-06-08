require 'csv'


class Matchups

    def initialize
        @mups = Array.new()

          CSV.foreach('app/models/IEMatFOR2012-06-10UPDATED2012-06-03.csv', :headers => :first_row) { |row|
            #player_name = "#{row['first_name']} #{row['last_name']}"
            #opp_name = "#{row['opp_first_name']} #{row['opp_last_name']}"
            #@matchups[player_name] = {opponent: opp_name, rating: row['matchup_rating'],
                                    #analysis: row['analysis']}
            @mups.push(row)
          }


    end

    def get_matchups
      return @mups
    end

    def get_player( player_name )
      return @mups[player_name]
    end
end

