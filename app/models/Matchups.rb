require 'csv'
require 'xmlsimple'
require "PlayerIdMapper"

class Matchups

    def initialize( date )
        @mups = Hash.new()
        todays_date = DateTime.strptime(date, "%Y%m%d").strftime(format='%F')
        iemup_glob = 'app/models/IEMatFOR' + todays_date + '*.csv'
        todays_file = Dir.glob(iemup_glob)
        puts "Today: #{todays_date} file glob: #{iemup_glob} files: #{todays_file}"

        todays_file.each { |filename|
          CSV.foreach(filename, :headers => :first_row) { |row|
            player_name = "#{row[4]} #{row[5]}"
            opp_name = "#{row[7]} #{row[8]}"
            matchup = { :statsid => row[3], :player => player_name, :opponent => opp_name,
                        :rating => row[10].to_i, :analysis => row[11]}
            @mups[player_name] = matchup
            @mups[ PlayerIdMapper.instance.map_statsid_to_cbsid( row[3] ) ] = matchup
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

