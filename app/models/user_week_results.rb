class UserWeekResults < ActiveRecord::Base
  attr_accessible :result, :user_id, :week, :win, :loss

  belongs_to :user
end
