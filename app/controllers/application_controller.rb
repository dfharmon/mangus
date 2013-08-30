class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  #protect_from_forgery

  def after_sign_in_path_for(resource)
    latest_week = Game.pluck(:week).sort.uniq.last
    "?week=#{latest_week}"
  end
end
