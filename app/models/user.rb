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

    games.each do |g|
      user_bet = g.bets.where("user_id = #{self.id}")
      raise "There is more than one bet for User id=#{self.id} on game #{g.id}" if user_bet.count > 1
      if user_bet.first.pick_team_id.nil? or g.winner != user_bet.first.pick_team
        user_bet.first.update_attributes(won: false)
        self.update_attributes(total_cash: self.total_cash.to_i - user_bet.first.amount)
      else
        user_bet.first.update_attributes(won: true)
        self.update_attributes(total_cash: self.total_cash.to_i + user_bet.first.amount)
      end
    end
  end

end
