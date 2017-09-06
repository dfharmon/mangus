module ApplicationHelper

  def us_timezones
    us = TZInfo::Country.get('US')
    us.zone_identifiers
  end
end
