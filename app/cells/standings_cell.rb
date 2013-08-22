class StandingsCell < Cell::Rails

  def display
    @games = Game.all

    render
  end

end
