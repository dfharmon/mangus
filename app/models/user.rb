class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #:registerable, :recoverable
  mount_uploader :avatar, AvatarUploader

  has_many :bets
  has_many :games, through: :bets

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable
  attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :total_cash, :name, :avatar
  attr_accessor :total_cash



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

  # Tallys results for a week (or for all time if a week is not specified)
  def get_results(week = nil)
    winnings = 0.00
    wins = 0
    loss = 0

    games = Game.where(final: true)
    games = games.where(week: week) unless week.nil?

    # User must have 2 large bets per week, get starting number of large bets per week
    largebets = {}
    weeks = (week.nil?) ? Game.pluck(:week).sort.uniq : [week]
    weeks.each do |w|
      largebets[w] = self.bets.joins(:game).where(amount: 4.00, games: {week: w}).count
    end

    games.each do |g|
      user_bet = g.bets.where(user_id: self.id)
      raise "There is more than one bet for User id=#{self.id} on game #{g.id}" if user_bet.count > 1
      if user_bet.empty? or user_bet.first.pick_team_id.nil? or g.winner != user_bet.first.pick_team
        adj = (largebets[g.week] < 2) ? 4.00 : 1.00
        largebets[g.week] += 1
        winnings -= (user_bet.empty?) ? adj : user_bet.first.amount
        loss += 1
      else
        winnings += user_bet.first.amount
        wins += 1
      end
    end
    return winnings, wins, loss
  end


end
