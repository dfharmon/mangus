class GamesController < ApplicationController
  require "#{Rails.root}/lib/score_grabber.rb"
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to games_url, notice: 'game was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def edit
    @game = Game.find(params[:id])
  end

  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
    end
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
