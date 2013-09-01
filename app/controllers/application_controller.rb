class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  #protect_from_forgery
  after_filter :add_flash_to_header


  def after_sign_in_path_for(resource)
    latest_week = Game.pluck(:week).sort.uniq.last
    "?week=#{latest_week}"
  end

  def add_flash_to_header
    # only run this in case it's an Ajax request.
    return unless request.xhr?

    # add different flashes to header
    response.headers['X-Flash-Error'] = flash[:error] unless flash[:error].blank?
    response.headers['X-Flash-Warning'] = flash[:warning] unless flash[:warning].blank?
    response.headers['X-Flash-Notice'] = flash[:notice] unless flash[:notice].blank?
    response.headers['X-Flash-Message'] = flash[:message] unless flash[:message].blank?

    # make sure flash does not appear on the next page
    flash.discard
  end
end
