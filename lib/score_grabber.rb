require 'open-uri'
module ScoreGrabber
  # use reg in regular season
  BASEURL2 = "http://scores.nbcsports.msnbc.com/fb/scoreboard.asp?seasontype=reg&week="

  def self.games_in_week(week = 1)
    pp "w: #{week}"
    games = []
    doc = Hpricot(open("#{BASEURL2}#{week}"))
    master_doc = doc.search("div//[@class='shsScoreboardDaily']")
    rows = master_doc.search("div//[@class='shsDivRow']")

    day = nil
    rows.each do |r|

      next if r.search("[@class='shsDayLabel']").count > 0
      lookup_day = r.previous_sibling.search("[@class='shsDayLabel']")
      pp lookup_day
      day = lookup_day.first.inner_html if lookup_day.count > 0
      lookup_game = r.search("div//[@class='shsScoreboardCol']")

      if lookup_game.count > 0
        lookup_game.each do |g|
          next if g.inner_html == "&nbsp;"
          time = 'Final' if g.search("td//[@class='shsNamD']").try(:[], 1).try(:inner_html) == 'Final'
          time ||= g.search("span//[@class='shsTimezone shsMTZone']").inner_html

          # TODO Had to remove the || to get the games to initially scan. FIX it, Amy
          #time ||= (time.present?) ? Time.parse("#{day} #{time}").utc : g.search("td//[@class='shsNamD']").first.inner_html

          time = (time.present?) ? Time.parse("#{day} #{time}") : g.search("td//[@class='shsNamD']").first.inner_html


          visit = g.search("a//[@href]").first.try(:inner_html)
          home = g.search("a//[@href]")[1].try(:inner_html)
          next if visit.nil? or home.nil?

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
            home: home.gsub('LA', 'Los Angeles'),
            home_score: home_score,
            visit: visit.gsub('NY', 'New York'),
            visit: visit.gsub('LA', 'Los Angeles'),
            visit_score: visit_score
          }
        end
      end
    end
    games
  end
end
