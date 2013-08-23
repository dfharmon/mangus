class StandingsCell < Cell::Rails

  def display
    @users = User.all

    render
  end

end
