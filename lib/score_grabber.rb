module ScoreGrabber
  # Will need to switch from the NBA/MLB once some NFL games are up
  BASEURL = 'http://scores.nbcsports.msnbc.com/ticker/data/gamesMSNBC.js.asp?jsonp=true&sport=MLB&period='

  # Get all the games on a given day
  # returns an array of the games.  Each game contains 3 hashes
  #  * game_info (General info like time and status)
  #  * home_info (Info on the home team. Including score)
  #  * visitor_info (Info on the visiting team. Including score)
  def self.games_on_day(day = Date.today)
    games = []
    response = RestClient.get "#{BASEURL}#{day.strftime("%Y%m%d")}"
    response.gsub!('shsMSNBCTicker.loadGamesData(', '').gsub!(');', '')
    json = JSON.parse(response)
    json['games'].each do |game|
      o = Ox.parse game

      games << {
          visitor_info: o.nodes.select { |x| x.value=='visiting-team' }.first.attributes,
          home_info: o.nodes.select { |x| x.value=='home-team' }.first.attributes,
          game_info: o.nodes.select { |x| x.value=='gamestate' }.first.attributes
      }
    end
    games
  end

  def self.games_in_week(week = Date.today)
    week_num = week.strftime("%W").to_i
    games = []
    (1..7).each do |i|
      games += games_on_day(Date.commercial(week.year, week_num+1, i))
    end
    games
  end
end
