class Message < ActiveRecord::Base
  belongs_to :message_category
  attr_accessible :content, :message_category_id

  validates_uniqueness_of :content
  validates_presence_of :content, :message_category_id
end