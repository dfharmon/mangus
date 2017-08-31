module SpreadGrabber
  # Will need to switch from the NBA/MLB once some NFL games are up
  # Use NFL instead of NFLPreseason for regular season
  # SPREAD_BASEURL = 'http://xml.pinnaclesports.com/pinnacleFeed.aspx?sportType=Football&sportsubtype=NFL'

  SPREAD_BASEURL = 'http://sportsfeeds.bovada.lv/basic/NFL.xml'

  # Get current spreads
  # Sometimes this is returning a 500 error, if it does... run it again
  def self.current_spreads
    response = RestClient.get SPREAD_BASEURL
    o = Ox.parse response
    evs = o.nodes[2].nodes.select { |x| x.value=='events' }.first.nodes
    # Go through the events
    spreads = []
    evs.each do |e|
      begin
        #Is there data?
        teams = []
        spread = "OFF"
        time = e.nodes.select { |y| y.value=='event_datetimeGMT' }.first.nodes.first
        parts = e.nodes.select { |y| y.value=='participants' }
        #binding.pry
        parts.first.nodes.each do |part|
          teams << {
            draw: part.nodes.select { |x| x.value=='visiting_home_draw' }.first.nodes.first,
            name: part.nodes.select { |x| x.value=='participant_name' }.first.nodes.first
          }
        end
        pers = e.nodes.select { |y| y.value=='periods' }

        #Is there spread data
        sp = pers.first.nodes.first.nodes.select { |p| p.value=='spread' }

        #Is there a spread on the score
        me = sp.first.nodes.select { |z| z.value=='spread_home' }

        spread = me.first.nodes.first

      rescue => e
        pp e.message
        pp e.backtrace
      end

      spreads << {
        time: "#{time} GMT",
        teams: teams,
        spread: spread
      }
    end
    spreads
  end

  def self.alternate_spreads
    response = RestClient.get SPREAD_BASEURL
    o = Ox.parse response

    #evs = o.nodes[0]
    evs = o.nodes[0].nodes


    # Go through the events
    spreads = []
    evs.each do |e|
      # e = game(s) date
      next if e.nodes.blank?
      begin
        games = e.nodes
        games.each do |game|
          spread = "OFF"

          teams = [{name: game.nodes[0].attributes[:NAME]}, {name: game.nodes[1].attributes[:NAME]}]
          puts "TEAMS #{teams}"
          begin
            spread = game.nodes[0].nodes.first.nodes.first.attributes[:NUMBER].to_i
            puts "SPREAD #{spread}"
          rescue
          end
          spreads << {
            teams: teams,
            spread: spread
          }
        end

      rescue => e
        pp e.message
        pp e.backtrace
      end

    end
    spreads
  end
end
