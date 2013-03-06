require 'csv'


class Matchups

    def initialize
        @mups = Hash.new()
        todays_date = "2013-04-04" #DateTime.now().strftime(format='%F')
        iemup_glob = 'app/models/IEMatFOR' + todays_date + '*.csv'
        todays_file = Dir.glob(iemup_glob)
        puts "Today: #{todays_date} file glob: #{iemup_glob} files: #{todays_file}"

        todays_file.each { |filename|
          CSV.foreach(filename, :headers => :first_row) { |row|
            player_name = "#{row[4]} #{row[5]}"
            opp_name = "#{row[7]} #{row[8]}"
            matchup = {:player => player_name, :opponent => opp_name, :rating => row[10].to_i, :analysis => row[11]}
            @mups[player_name] = matchup
          }
        }
    end

    def get_matchups
      return @mups
    end

    def get_player( player_name )
      return @mups[player_name]
    end
end

