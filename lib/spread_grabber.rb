module SpreadGrabber
  # Will need to switch from the NBA/MLB once some NFL games are up
  BASEURL = 'http://xml.pinnaclesports.com/pinnacleFeed.aspx?sportType=Football&sportsubtype=NFL'

  # Get current spreads
  def self.current_spreads
    response = RestClient.get BASEURL
    o = Ox.parse response
    evs = o.nodes[2].nodes.select { |x| x.value=='events' }.first.nodes
    # Go through the events
    spreads = []
    evs.each do |e|
      begin
      #Is there data?
      teams = []
      time = e.nodes.select{ |y| y.value=='event_datetimeGMT' }.first.nodes.first
      parts = e.nodes.select{ |y| y.value=='participants' }
      #binding.pry
      parts.first.nodes.each do |part|
        teams << {
          draw: part.nodes.select{|x| x.value=='visiting_home_draw'}.first.nodes.first,
          name: part.nodes.select{|x| x.value=='participant_name'}.first.nodes.first
        }
      end
      pers = e.nodes.select{ |y| y.value=='periods' }

      #Is there spread data
      sp = pers.first.nodes.first.nodes.select{|p| p.value=='spread'}

      #Is there a spread on the score
      me = sp.first.nodes.select{|z| z.value=='spread_home'}

      spread = me.first.nodes.first
      spreads << {
          time: time,
          teams: teams,
          spread: spread
      }
      rescue => e
      end
    end
    spreads
  end

  # NOTE: This function may not stay here, this is just for testing.  Currently its going to use a game hash from
  # the score grabber.  This will most likely need to be swapped out when we have real game and team models.
  def self.find_game_spread(spreads, game)
    home_team = {draw: 'Home', name: "#{game[:home_info][:display_name]} #{game[:home_info][:nickname]}"}
    visit_team = {draw: 'Visiting', name: "#{game[:visitor_info][:display_name]} #{game[:visitor_info][:nickname]}"}
    date = "#{game[:game_info][:gamedate]}/#{Date.today.year} #{game[:game_info][:gametime]} -04:00"
    utcdate = DateTime.strptime(date, '%m/%d/%Y %l:%M %p %Z').utc
    spreaddate = utcdate.strftime('%Y-%m-%d %H:%M')
    spreads.select{|x| x[:time] == spreaddate && x[:teams].include?(home_team) && x[:teams].include?(visit_team)}.first[:spread]
  end
end
