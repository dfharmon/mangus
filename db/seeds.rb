# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
user = User.new :email => 'nfluser@admin.com', :password => 'nflpass123', :password_confirmation => 'nflpass123'
user.admin = true # setting :admin => true on the User.create line would save a 'f' in sqlite
user.save

