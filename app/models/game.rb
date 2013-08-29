require 'score_grabber'
require 'spread_grabber'

class Game < ActiveRecord::Base
  attr_accessible :favorite_id, :spread, :home_team, :away_team, :start_date, :week, :winner

  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  has_many :bets

  # Run me each day to scan the entire season and see if I can update or create any new info
  def self.scan_games
    spreads = SpreadGrabber.current_spreads

    # Change to 17 when in regular season
    (1..5).each do |week|
      weekly_games = ScoreGrabber.games_in_week(week)
      weekly_games.each do |game|
        home_team = Team.where(location: game[:home]).first
        away_team = Team.where(location: game[:visit]).first

        if game[:home].match(/New York/)
          home_team = Team.where(location: 'New York', mascot: game[:home].gsub('New York ', '')).first
        end
        if game[:visit].match(/New York/)
          away_team = Team.where(location: 'New York', mascot: game[:visit].gsub('New York ', '')).first
        end

        if home_team and away_team
          found_game = Game.where(week: week, home_team_id: home_team, away_team_id: away_team).first
          unless found_game
            found_game = Game.create(week: week, home_team: home_team, away_team: away_team)
          end

          found_game.start_date = game[:time] if game[:time].is_a?(Time)
          found_game.final = true if game[:time] == 'Final'
          found_game.home_score = game[:home_score] unless game[:home_score].nil?
          found_game.away_score = game[:visit_score] unless game[:visit_score].nil?
          found_game.spread = found_game.find_game_spread(spreads)
          found_game.save!
        end
      end
    end
  end

  # If the game is found and the spread if found it will return the home based spread
  # If the game is found but the spread is not yet listed it will be "OFF"
  # If the game is not found it will be nil
  def find_game_spread(spreads)
    home_team = {draw: 'Home', name: self.home_team.location}
    home_team[:name] = "#{home_team[:name]} #{self.home_team.mascot}" if home_team[:name] == 'New York'

    visit_team = {draw: 'Visiting', name: self.away_team.location}
    visit_team[:name] = "#{visit_team[:name]} #{self.away_team.mascot}" if visit_team[:name] == 'New York'

    begin
      found_spreads = spreads.select { |x| Time.parse(x[:time].to_s) == Time.parse(self.start_date.to_s) &&
          x[:teams][1][:name].grep(/#{home_team[:name]}/).count > 0 &&
          x[:teams][0][:name].grep(/#{visit_team[:name]}/).count > 0 }
    rescue => e
      pp e
    end
    return found_spreads.first[:spread] if found_spreads and found_spreads.count > 0
  end

  def winner
    self.home_score > self.away_score ? self.home_team : self.away_team
  end

  #def find_pick(user_id)
  #  bet = find_bet(user_id)
  #  pick = bet.nil? ? nil : bet.pick_team_id
  #
  #  #pick = User.find(user_id).bets.where("game_id=#{self.id}")[0].nil? ? nil : User.find(user_id).bets.where("game_id=#{self.id}")[0].pick_team_id
  #
  #  if pick == self.away_team_id.to_i
  #    return "away"
  #  elsif pick == self.home_team_id.to_i
  #    return "home"
  #  else
  #    return nil
  #  end
  #end

  def get_bet(user_id)
    bet = User.find(user_id).bets.where("game_id=#{self.id}")[0]
    return nil if bet.nil?
    bet
  end
end
