# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# user = User.new :email => 'nfluser@admin.com', :password => 'nflpass123', :password_confirmation => 'nflpass123', :avatar => 'default.gif'
# user.admin = true # setting :admin => true on the User.create line would save a 'f' in sqlite
# user.save

Team.create(location: "Dallas", mascot: "Cowboys")
Team.create(location: "Green Bay", mascot: "Packers")
Team.create(location: "Jacksonville", mascot: "Jaguars")
Team.create(location: "Kansas City", mascot: "Chiefs")
Team.create(location: "Miami", mascot: "Dolphins")
Team.create(location: "Atlanta", mascot: "Falcons")
Team.create(location: "Chicago", mascot: "Bears")
Team.create(location: "Minnesota", mascot: "Vikings")
Team.create(location: "New England", mascot: "Patriots")
Team.create(location: "New Orleans", mascot: "Saints")
Team.create(location: "Arizona", mascot: "Cardinals")
Team.create(location: "Baltimore", mascot: "Ravens")
Team.create(location: "New York", mascot: "Jets")
Team.create(location: "New York", mascot: "Giants")
Team.create(location: "Oakland", mascot: "Raiders")
Team.create(location: "Carolina", mascot: "Panthers")
Team.create(location: "Buffalo", mascot: "Bills")
Team.create(location: "Philadelphia", mascot: "Eagles")
Team.create(location: "Pittsburgh", mascot: "Steelers")
Team.create(location: "San Diego", mascot: "Chargers")
Team.create(location: "Cleveland", mascot: "Browns")
Team.create(location: "Cincinnati", mascot: "Bengals")
Team.create(location: "San Francisco", mascot: "49ers")
Team.create(location: "Seattle", mascot: "Seahawks")
Team.create(location: "St. Louis", mascot: "Rams")
Team.create(location: "Detroit", mascot: "Lions")
Team.create(location: "Denver", mascot: "Broncos")
Team.create(location: "Tampa Bay", mascot: "Buccaneers")
Team.create(location: "Tennessee", mascot: "Titans")
Team.create(location: "Washington", mascot: "Redskins")
Team.create(location: "Indianapolis", mascot: "Colts")
Team.create(location: "Houston", mascot: "Texans")

MessageCategory.create(name: 'bets')
MessageCategory.create(name: 'results_lost')
MessageCategory.create(name: 'results_won')

Message.create(content: 'Nice bets. Good luck!', message_category_id: MessageCategory.find_by_name('bets').id)
Message.create(content: 'hmmnn...you sure about those? Well, you always have your fantasy team', message_category_id: MessageCategory.find_by_name('bets').id)
Message.create(content: "you don't take those 'skills' to Vegas, do you?", message_category_id: MessageCategory.find_by_name('bets').id)

Message.create(content: "Ouch. not the best week for this 'ol sport'?", message_category_id: MessageCategory.find_by_name('results_lost').id)
Message.create(content: "Curling is a nice up-and-coming sport to follow.", message_category_id: MessageCategory.find_by_name('results_lost').id)
Message.create(content: "Put that coffee down. Coffee is for closers!", message_category_id: MessageCategory.find_by_name('results_lost').id)
Message.create(content: "Next week I'll do a 360 and get headed in the right direction.", message_category_id: MessageCategory.find_by_name('results_lost').id)
Message.create(content: "It’s like déjà vu all over again.", message_category_id: MessageCategory.find_by_name('results_lost').id)


Message.create(content: "This guy crushed it!", message_category_id: MessageCategory.find_by_name('results_won').id)
Message.create(content: "Nice work, and without ever leaving the couch!", message_category_id: MessageCategory.find_by_name('results_won').id)
Message.create(content: "Whoa. Clairvoyant are we?", message_category_id: MessageCategory.find_by_name('results_won').id)
Message.create(content: "I feel like I'm the best, but you're not going to get me to say that.", message_category_id: MessageCategory.find_by_name('results_won').id)
Message.create(content: "Whoa, this ninja's headin to Vegas.", message_category_id: MessageCategory.find_by_name('results_won').id)

Team.find_by_location('St. Louis').update_column('location', 'Los Angeles')
Team.find_by_location('San Diego').update_column('location', 'Los Angeles')
