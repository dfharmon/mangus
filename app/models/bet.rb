class Bet < ActiveRecord::Base
  validates :game_id, :uniqueness => {:scope => :user_id}
  validates :amount, :pick_team_id, :game_id, :user_id, presence: true

  attr_accessible :won, :counted

  belongs_to :user
  belongs_to :game
  belongs_to :pick_team, class_name: Team

  def self.make_bets(params, current_user)
    week = params[:week]

    games = params[:games]
    games.each do |game_id, bets|
      next if bets["winner"].nil?
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
      end
      user_bet.save!
    end
  end

  def max_bets
    #bets_for_week = user.bets.where(:week_id = week)
    #bets

  end

  #def pick_team
  #   Team.find(self.pick_team_id).nil? ? nil : Team.find(self.pick_team_id)
  #end

  def correct
    self.game.winner == self.pick_team
  end
end
