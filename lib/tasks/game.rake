desc 'NFL Tasks'
namespace :nfl do
  desc 'Update Games'
  task :update => :environment do
    Game.scan_games
  end
end
