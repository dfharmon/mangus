module SpreadGrabber
  # Will need to switch from the NBA/MLB once some NFL games are up
  SPREAD_BASEURL = 'http://xml.pinnaclesports.com/pinnacleFeed.aspx?sportType=Football&sportsubtype=NFL'

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

  # NOTE: This function may not stay here, this is just for testing.  Currently its going to use a game hash from
  # the score grabber.  This will most likely need to be swapped out when we have real game and team models.
  #
  # If the game is found and the spread if found it will return the home based spread
  # If the game is found but the spread is not yet listed it will be "OFF"
  # If the game is not found it will be nil
  #
  # Example
  #
  # games = ScoreGrabber.games_in_week(1)
  # spreads = SpreadGrabber.current_spreads
  # SpreadGrabber.find_game_spread(spreads, games.first)
  # => "OFF"
  def self.find_game_spread(spreads, game)
    home_team = {draw: 'Home', name: "#{game[:home]}"}
    visit_team = {draw: 'Visiting', name: "#{game[:visit]}"}
    found_spreads = spreads.select { |x| Time.parse(x[:time].to_s) == Time.parse(game[:time].to_s) &&
        x[:teams].grep(home_team) &&
        x[:teams].grep(visit_team) }
    return found_spreads.first[:spread] if found_spreads.count > 0
  end
end
