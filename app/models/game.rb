require 'score_grabber'
require 'spread_grabber'

class Game < ActiveRecord::Base
  attr_accessible :favorite_id, :spread, :home_team, :away_team, :start_date, :week, :winner, :last_season_end

  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  has_many :bets

  # Run me each day to scan the entire season and see if I can update or create any new info
  def self.scan_games
    spreads = SpreadGrabber.alternate_spreads

    ((Game.current_week - 1)..22).each do |week|
      next if week == 21
      weekly_games = ScoreGrabber.games_in_week(week)
      weekly_games.each do |game|
        home_team = Team.where(location: game[:home]).first
        away_team = Team.where(location: game[:visit]).first

        pp "game #{game}"
        if game[:home].match(/New York/) or game[:home].match(/NY/)
          home_team = Team.where(location: 'New York', mascot: game[:home].gsub('New York ', '')).first
          home_team ||= Team.where(location: 'New York', mascot: game[:home].gsub('NY ', '')).first
        end
        if game[:home].match(/Los Angeles/)
          home_team = Team.where(location: 'Los Angeles', mascot: game[:home].gsub('Los Angeles ', '')).first
        end
        if game[:visit].match(/New York/) or game[:visit].match(/NY/)
          away_team = Team.where(location: 'New York', mascot: game[:visit].gsub('New York ', '')).first
          away_team ||= Team.where(location: 'New York', mascot: game[:visit].gsub('NY ', '')).first
        end
        if game[:visit].match(/Los Angeles/)
          away_team = Team.where(location: 'Los Angeles', mascot: game[:visit].gsub('Los Angeles ', '')).first
        end
        if home_team and away_team
          found_game = Game.where(week: week, home_team_id: home_team, away_team_id: away_team).where('start_date > ?', Game.last_season_end).first
          unless found_game
            found_game = Game.create(week: week, home_team: home_team, away_team: away_team)
          end

          found_game.start_date = game[:time] if game[:time].is_a?(Time)
          found_game.final = true if game[:time].to_s == 'Final'
          found_game.home_score = game[:home_score] unless game[:home_score].nil?
          found_game.away_score = game[:visit_score] unless game[:visit_score].nil?
          found_game.spread = found_game.find_game_spread(spreads) unless found_game.spread and found_game.spread.match(/[0-9]+/)
          found_game.spread = 'OFF' if found_game.spread.nil?
          found_game.save!
        end
      end
    end
  end

  def self.current_week
    week1start = Date.parse('Tue, 05 Sep 2017')
    thisweekstart = Date.today.beginning_of_week(start_day = :tuesday)

    #week = ((thisweekstart - week1start) / 7 ).to_i + 1
    week = ((thisweekstart - week1start).to_i / 7.0 ).ceil + 1
    week = 22 if week == 21
    return (week > 0) ? week : 1
  end

  # If the game is found and the spread if found it will return the home based spread
  # If the game is found but the spread is not yet listed it will be "OFF"
  # If the game is not found it will be nil
  def find_game_spread(spreads)
    home_team = {draw: 'Home', name: self.home_team.location}
    home_team[:name] = "#{home_team[:name]} #{self.home_team.mascot}"# if home_team[:name] == 'New York'

    visit_team = {draw: 'Visiting', name: self.away_team.location}
    visit_team[:name] = "#{visit_team[:name]} #{self.away_team.mascot}"# if visit_team[:name] == 'New York'

    begin
      found_spreads = spreads.select { |x|
          #(Time.parse(x[:time].to_s) == Time.parse(self.start_date.to_s) ||
          #Time.parse(x[:time].to_s) == (Time.parse(self.start_date.to_s) - 1.hour) ) &&
          x[:teams][0][:name].scan(/#{home_team[:name]}/).count > 0 &&
          x[:teams][1][:name].scan(/#{visit_team[:name]}/).count > 0
          }
    rescue => e
      pp e
    end
    return found_spreads.first[:spread] if found_spreads and found_spreads.count > 0
  end

  def winner
    # Push
    return nil if (self.away_score.to_f == (self.home_score.to_f + self.spread.to_f)) or self.final.nil?
    self.away_score.to_f > (self.home_score.to_f + self.spread.to_f) ? self.away_team : self.home_team
  end

  def get_bet(user_id)
    User.find(user_id).bets.find_by_game_id(self.id)
  end

  def self.last_season_end
    'March 01, 2017'.to_date
  end
end
