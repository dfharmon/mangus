require 'score_grabber'

class Bet < ActiveRecord::Base
  validates :game_id, :uniqueness => {:scope => :user_id}
  validates :amount, :pick_team_id, :game_id, :user_id, presence: true

  attr_accessible :won, :counted

  belongs_to :user
  belongs_to :game
  belongs_to :pick_team, class_name: Team

  def self.validate_bets(params, current_user)
    games = params[:games] #sends in saved bets AND new bets
    current_week = params[:current_week].to_i
    game_count = Game.where('start_date > ?', Game.last_season_end).where(week: current_week).count
    large_bets_made = 0
    large_bets_needed = 0
    complete_bets = 0
    playoffs = current_week > 17 and current_week < 21
    superbowl = current_week == 21

    if !playoffs and !superbowl
      # count large bets
      games.each do |game_id, bets|
        next if bets["winner"].nil?
        bets.each do |key, value|
          if key == "bet"
            if value.to_i == 4
              large_bets_made += 1
            end
          end
        end
        complete_bets += 1
      end

      bets_needed = game_count - complete_bets
      case bets_needed
        when 1
          large_bets_needed = 1
        when 0
          large_bets_needed = 2
      end

      error = nil
      if large_bets_made > 2
        error = "You have exceeded the $4.00 bet limit (2). Watch yer wallet there cowboy. New bets were not saved - please adjust."
      elsif large_bets_made < large_bets_needed
        error = "You must make 2 $4.00 bets. Live a little sport. New bets were not saved - please adjust"
      end
    end

    if error
      return error
    else
      return Bet.make_bets(params, current_user)
    end
  end

  def correct
    self.game.winner == self.pick_team
  end

  private

  def self.make_bets(params, current_user)
    games = params[:games]
    begin
      transaction do
        games.each do |game_id, bets|
          game = Game.find(game_id)
          # do not save if a bet was submitted after game started or there is no bet
          # TODO return msg if some bets were not saved
          next if bets["winner"].nil? #or game.start_date.utc < Time.now
          user_bet = Bet.find_by_game_id_and_user_id(game_id, current_user.id)
          user_bet = Bet.new if user_bet.nil?

          user_bet.user_id = current_user.id
          user_bet.game_id = game_id

          bets.each do |key, value|
            if key == "bet"
              user_bet.amount = value
            elsif key == "winner"
              user_bet.pick_team_id = value
            end
            user_bet.save
          end
        end
      end
      return true
    rescue => e
      return e.message
    end
  end
end
