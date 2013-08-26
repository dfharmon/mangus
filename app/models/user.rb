class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #:registerable, :recoverable

  has_many :bets
  has_many :games, through: :bets

  devise :database_authenticatable, :rememberable, :trackable, :validatable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :total_cash, :avatar, :name, :wins, :losses



  validates :name, :email, :presence => :true

  # WILL MAKE A JOB THAT CALLS THIS FOR EVERY USER AFTER MONDAY NIGHT GAME
  def tally_week_bets(week)
    games = Game.find_by_sql ["SELECT games.* from games INNER JOIN bets ON games.id=bets.game_id where bets.user_id=? and week=?", self.id, week]

    wins = 0
    losses = 0
    cash = 0

    games.each do |g|
      # TODO CHANGE THIS to dynamic user!!!!!!
      user_bet = g.bets.where(user_id: 1)

      # TODO DUSTY WHY DOESNT THIS WORK??????
      #user_bet = g.bets.where(user_id: 1, counted: false)

      raise "There is more than one bet for User id=#{self.id} on game #{g.id}" if user_bet.count > 1

      bet = Bet.find(user_bet.first.id)
      raise "Bet has already been counted" if bet.counted

      if bet.pick_team_id.nil? or g.winner != bet.pick_team
        bet.update_attributes(won: false)
        self.update_attributes(total_cash: self.total_cash.to_i - bet.amount, losses: self.losses += 1)
        losses += 1
        cash -= bet.amount
      else
        bet.update_attributes(won: true)
        self.update_attributes(total_cash: self.total_cash.to_i + bet.amount, wins: self.wins += 1)
        wins += 1
        cash += bet.amount
      end
      bet.counted = true
      bet.save
    end
    puts "WINS #{wins}"
    puts "LOSSES #{losses}"
    puts "CASH #{cash}"

    puts "WINS #{self.wins}"
    puts "LOSSES #{self.losses}"
    puts "CASH #{self.total_cash}"

    Standings.create(user_id: self.id, wins: wins, losses: losses, week: week, total_cash: cash)
  end
end
