class GamesController < ApplicationController
  require "#{Rails.root}/lib/score_grabber.rb"

  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'game was successfully updated.' }
      else
        flash.now[:error] = 'Please correct the following errors'
        format.html { render action: "edit" }
      end
    end
  end

  def index
    week = params[:week].nil? ? Game.current_week : params[:week]
    @games = Game.where(week: week.to_i)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  def place_bets
    result = Bet.validate_bets(params, current_user)

    respond_to do |format|
      if result != true
        flash[:error] = result
      else
        flash[:notice] = "Nice bets. Good luck!"
        format.json { head :no_content }
      end
    end
  end

  def user_bets
    @week = params[:week]
    @games = Game.where(final: true)
    @games = @games.where(week: @week)
    @user = User.find(params[:user_id])

    respond_to do |format|
      format.html { render "user_bets" }
      format.json { head :no_content }
    end
  end
end