class User < ActiveRecord::Base
  # validates :name, presence: true
  # validates :email, presence: true
  # validates :name, uniqueness: true

  devise :database_authenticatable, :rememberable, :trackable, :validatable, :registerable, :recoverable
         attr_accessible :email, :password, :password_confirmation, :remember_me, :admin, :total_cash, :name, :avatar, :timezone
  attr_accessor :total_cash

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  #:registerable, :recoverable
  mount_uploader :avatar, AvatarUploader

  has_many :bets
  has_many :games, through: :bets
  has_many :user_week_resultses

  # Tallys results for a user, returns array where the 0'th element is the total, and the others are for each week
  def get_results()
    winnings = []
    wins = []
    loss = []

    winnings[0] = 0.00
    wins[0] = 0
    loss[0] = 0

    # User must have 2 large bets per week, get starting number of large bets per week
    largebets = {}
    missedbets = {}
    weeks = (1..Game.current_week)
    weeks.each do |w|
      next unless self.active
      res = UserWeekResults.where(week: w, user_id: self.id).where('created_at > ?', Game.last_season_end)
      if w < Game.current_week and res.count > 0
        res = res.first
        winnings[w] = res.result
        wins[w] = res.win
        loss[w] = res.loss
      else
        winnings[w] = 0.00
        wins[w] = 0
        loss[w] = 0
        largebets[w] = self.bets.joins(:game).where(amount: 4.00, games: {week: w}).select{|b| b.created_at > Game.last_season_end}.count
        missedbets[w] = Game.where('start_date > ?', Game.last_season_end).where(week: w).count - self.bets.joins(:game).where(games: {week: w}).where('start_date > ?', Game.last_season_end).count

        games = Game.where('start_date > ?', Game.last_season_end).where(final: true, week: w)

        if w <= 17
          games.each do |g|
            user_bet = g.bets.where(user_id: self.id)
            raise "There is more than one bet for User id=#{self.id} on game #{g.id}" if user_bet.count > 1

            if user_bet.empty? or user_bet.first.pick_team_id.nil? or (g.winner.present? and g.winner != user_bet.first.pick_team)
              adj = nil
              if user_bet.empty?
                adj = 1.00
                if (missedbets[w] < 3 and largebets[w] < 2)
                  adj = 4.00
                  largebets[w] += 1
                end
                missedbets[w] -= 1
              end
              winnings[w] -= (adj.present?) ? adj : user_bet.first.amount
              loss[w] += 1
            elsif g.winner.nil?
              # push
            else
              winnings[w] += user_bet.first.amount
              wins[w] += 1
            end
          end

        elsif w >= 18 and w <= 20 # Playoffs
          games.each do |g|
            user_bet = g.bets.where(user_id: self.id)
            if user_bet.empty? or user_bet.first.pick_team_id.nil? or (g.winner.present? and g.winner != user_bet.first.pick_team)
              adj = 4.00 if user_bet.empty?
              winnings[w] -= (adj.present?) ? adj : user_bet.first.amount
              loss[w] += 1
            elsif g.winner.nil?
              # push
            else
              winnings[w] += user_bet.first.amount
              wins[w] += 1
            end
          end

        elsif w == 22 # Superbowl
          games.each do |g|
            user_bet = g.bets.where(user_id: self.id)
            if user_bet.empty? or user_bet.first.pick_team_id.nil? or (g.winner.present? and g.winner != user_bet.first.pick_team)
              adj = 12.00 if user_bet.empty?
              winnings[w] -= (adj.present?) ? adj : user_bet.first.amount
              loss[w] += 1
            elsif g.winner.nil?
              # push
            else
              winnings[w] += user_bet.first.amount
              wins[w] += 1
            end
          end

        end
        UserWeekResults.create(user_id: self.id, week: w, win: wins[w], loss: loss[w], result: winnings[w]) if w < Game.current_week and Game.where(week: w, final: nil).where('start_date > ?', Game.last_season_end).count == 0
      end
    end

    winnings[0] = winnings.sum
    wins[0] = wins.sum
    loss[0] = loss.sum
    return winnings, wins, loss
  end
end
