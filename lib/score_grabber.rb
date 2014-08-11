require 'open-uri'
module ScoreGrabber
  # use reg in regular season
  BASEURL2 = "http://scores.nbcsports.msnbc.com/fb/scoreboard.asp?seasontype=reg&week="

  def self.games_in_week(week = 1)
    games = []
    doc = Hpricot(open("#{BASEURL2}#{week}"))
    master_doc = doc.search("div//[@class='shsScoreboardDaily']")
    rows = master_doc.search("div//[@class='shsDivRow']")

    day = nil
    rows.each do |r|
      lookup_day = r.search("div//[@class='shsDayLabel']")
      day = lookup_day.first.inner_html if lookup_day.count > 0

      lookup_game = r.search("div//[@class='shsScoreboardCol']")

      if lookup_game.count > 0
        lookup_game.each do |g|
          time = g.search("span//[@class='shsTimezone shsMTZone']").inner_html
          time = (time.present?) ? Time.parse("#{day} #{time}").utc : g.search("td//[@class='shsNamD']").first.inner_html
          visit = g.search("a//[@href]").first.inner_html
          home = g.search("a//[@href]")[1].inner_html

          scores = g.search("td//[@class='shsTotD']")
          if scores.count > 0
            if scores[4].inner_html == 'OT'
              visit_score = scores[11].inner_html
              home_score = scores[17].inner_html
            else
              visit_score = scores[9].inner_html
              home_score = scores[14].inner_html
            end
          end
          games << {
              time: time,
              home: home.gsub('NY', 'New York'),
              home_score: home_score,
              visit: visit.gsub('NY', 'New York'),
              visit_score: visit_score
          }
        end
      end
    end
    games
  end
end
