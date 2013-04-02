require 'csv'
require 'xmlsimple'

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

    def load_id_mappings
       @map_cbsid_to_statsid = Hash.new
       @map_statsid_to_cbsid = Hash.new
       players = XmlSimple.xml_in('app/models/mlb-vendorkey.xml')

       players["player"].each do |player|
         #puts "cbs id: #{player['id']} stats id: #{player['statsid']}"
         @map_cbsid_to_statsid[player["id"]] = player["statsid"]
         @map_statsid_to_cbsid[player["statsid"]] = player['id']
       end
=begin
       puts "ID MAPPINGS"
       puts @map_cbsid_to_statid
       puts "******"
       puts @map_statsid_to_cbsid
       puts "ID MAPPINGS END"
=end
    end

    def map_cbsid_to_stats_id( cbs_id )
      return @map_cbsid_to_statsid[ cbs_id ]
    end

    def map_statsid_to_cbsid( stats_id )
      return @map_statsid_to_cbsid[ stats_id ]
    end
end

