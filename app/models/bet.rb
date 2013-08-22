class Bet < ActiveRecord::Base
  validates :game_id, :uniqueness => {:scope => :user_id}
  validates :amount, :pick_team_id, :game_id, :user_id, presence: true

  attr_accessible :won

  belongs_to :user
  belongs_to :game

  def self.make_bets(params)
    user = User.find(params[:user_id])
    week = params[:week]

    games = params[:games]
    games.each do |game_id, bets|
      next if bets["winner"].nil?
      user_bet = Bet.find_by_game_id_and_user_id(game_id, user.id)
      user_bet = Bet.new if user_bet.nil?

      user_bet.user_id = user.id
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

  def pick_team
     Team.find(self.pick_team_id).nil? ? nil : Team.find(self.pick_team_id)
  end

end
