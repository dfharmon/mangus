class GamesController < ApplicationController
  require "#{Rails.root}/lib/score_grabber.rb"

  def index
    @week = params[:week].nil? ? Game.current_week.to_i : params[:week].to_i
    @games = Game.where('start_date > ?', Game.last_season_end).where(week: @week.to_i).order('start_date')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  def place_bets
    result = Bet.validate_bets(params, current_user)

    respond_to do |format|
      if result.is_a?(Integer) and !result.zero?
        flash[:error] = "Some of your bets were not saved because those games have already started."
      elsif result != true
        flash[:error] = result
        #format.json { head result }
      else
        flash[:notice] = Message.where(message_category_id: MessageCategory.find_by_name('bets').id).sample.content

        format.json { head :no_content }
      end
    end
  end

  def user_bets
    @week = params[:week]
    @games = Game.where('start_date > ?', Game.last_season_end).where(final: true)
    @games = @games.where(week: @week).order('start_date')
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html { render "user_bets" }
      format.json { head :no_content }
    end
  end
end