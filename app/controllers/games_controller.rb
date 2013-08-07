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
    @games = ScoreGrabber.games_in_week(2)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end
end