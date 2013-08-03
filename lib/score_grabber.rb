require 'open-uri'
module ScoreGrabber
  # use reg in regular season
  BASEURL2 = "http://scores.nbcsports.msnbc.com/fb/scoreboard.asp?seasontype=pre&week="

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
              home: home.gsub('NY', 'New York'),
              visit: visit.gsub('NY', 'New York')
          }
        end
      end
    end
    games
  end
end
