require 'open-uri'
module ScoreGrabber
  # Will need to switch from the NBA/MLB once some NFL games are up
  BASEURL = 'http://scores.nbcsports.msnbc.com/ticker/data/gamesMSNBC.js.asp?jsonp=true&sport=NFL&period='

  # Get all the games on a given day
  # returns an array of the games.  Each game contains 3 hashes
  #  * game_info (General info like time and status)
  #  * home_info (Info on the home team. Including score)
  #  * visitor_info (Info on the visiting team. Including score)
  def self.games_on_day_old(day = Date.today)
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

  def self.games_in_week_old(week = Date.today)
    week_num = week.strftime("%W").to_i
    games = []
    (1..7).each do |i|
      games += games_on_day(Date.commercial(week.year, week_num+1, i))
    end
    games
  end

  BASEURL2 = "http://scores.nbcsports.msnbc.com/fb/scoreboard.asp?seasontype=reg&week="

  def self.games_in_week(week = 1)
    games = []
    doc = Hpricot(open("#{BASEURL2}#{week}"))
    master_doc = doc.search("table//[@style='width: 100%']")
    rows = master_doc.search("tr//")

    day = nil
    rows.each do |r|
      lookup_day = r.search("td//[@class='shsDayLabel']")
      day = lookup_day.first.inner_html if lookup_day.count > 0

      lookup_game = r.search("td//[@class='shsScoreboardCol']")

      if lookup_game.count > 0
        lookup_game.each do |g|
          time = g.search("td//[@class='shsTimezone shsMTZone']").inner_html
          visit = g.search("a//[@href]").first.inner_html
          home = g.search("a//[@href]").last.inner_html
          # TODO: Put the search to get the game score here....
          games << {
              time: Time.parse("#{day} #{time}").utc,
              home: home,
              visit: visit
          }
        end
      end
    end
    games
  end
end
