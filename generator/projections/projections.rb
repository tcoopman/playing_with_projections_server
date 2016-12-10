require_relative 'counter_projections.rb'
require_relative 'projections_per_month.rb'
require_relative 'top_5_projections.rb'
require_relative 'active_players.rb'

require 'json'
require 'pry'

def events(stream_name)
  response = File.read(stream_name)
  JSON.parse(response)
end

def run(stream_name)
  events = events(stream_name)

  puts
  puts "#{NumberOfPlayers.new.project(events)} players"
  puts "#{NumberOfPublishedQuizzes.new.project(events)} quizzes published"
  puts "#{NumberOfGamesPlayed.new.project(events)} games played"
  puts

  # puts "Quizzes published per month:"
  # QuizzesPublishedPerMonth.new.project(events).each do |month, count|
  #   puts "#{month}: #{count}"
  # end
  # puts
  #
  # puts "Games played per month:"
  # GamesPlayedPerMonth.new.project(events).each do |month, count|
  #   puts "#{month}: #{count}"
  # end
  # puts
  #
  # puts "Players who play the most:"
  # Top5PlayingPlayers.new.project(events).each do |player|
  #   puts "#{player[:first_name]} #{player[:last_name]} played #{player[:games_played]} games"
  # end
  # puts
  #
  # puts "Most played quizzes:"
  # Top5PlayedQuizzes.new.project(events).each do |quiz|
  #   puts "#{quiz[:quiz_title]}: played #{quiz[:count]} times"
  # end
  # puts

  date = DateTime.now
  puts "Active players on #{date}"
  ActivePlayers.new(events).on(date).each do |player|
    # puts player.inspect
    puts "#{player['first_name']} #{player['last_name']}: #{player[:games_played]} games played"
  end

end
