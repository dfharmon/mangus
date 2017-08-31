class StandingsCell < Cell::Rails
  include Devise::Controllers::Helpers
  helper_method :current_user

  def display
    @users = User.all
    user = current_user

    render if user and user.active
  end

end
