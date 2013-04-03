require "singleton"

class PlayerIdMapper
  include Singleton

  def initialize
    @map_cbsid_to_statsid = Hash.new
    @map_statsid_to_cbsid = Hash.new
    players = XmlSimple.xml_in('app/models/mlb-vendorkey.xml')

    players["player"].each do |player|
      puts "cbs id: #{player['id']} stats id: #{player['statsid']}"
      @map_cbsid_to_statsid[player["id"]] = player["statsid"]
      @map_statsid_to_cbsid[player["statsid"]] = player['id']
    end
  end

  def map_cbsid_to_stats_id(cbs_id)
    return @map_cbsid_to_statsid[cbs_id]
  end

  def map_statsid_to_cbsid(stats_id)
    return @map_statsid_to_cbsid[stats_id]
  end
end
