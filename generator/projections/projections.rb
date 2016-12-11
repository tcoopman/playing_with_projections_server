require_relative 'counter_projections.rb'
require_relative 'projections_per_month.rb'
require_relative 'top_5_projections.rb'
require_relative 'player_activity.rb'

require 'json'
require 'pry'

def events(stream_name)
  response = File.read(stream_name)
  JSON.parse(response).each do |event|
    event['timestamp'] = DateTime.parse(event['timestamp'])
    event['payload'] = OpenStruct.new(event['payload'])
  end.map{|event| OpenStruct.new(event)}
end

def print_examples(events)
  events.inject({}) do |accumulator, event|
    accumulator[event.type] ||= 0
    accumulator[event.type] += 1
    accumulator
  end.map do |type, count|
    {count: count, example: events.detect { |e| e.type == type }}
  end
end

def run(stream_name)
  events = events(stream_name)
  ap print_examples(events)

  puts
  puts "#{NumberOfPlayers.new.project(events)} players"
  puts "#{NumberOfPublishedQuizzes.new.project(events)} quizzes published"
  puts "#{NumberOfGamesPlayed.new.project(events)} games played"
  puts

  puts "Quizzes published per month:"
  QuizzesPublishedPerMonth.new.project(events).each do |month, count|
    puts "#{month}: #{count}"
  end
  puts

  puts "Games played per month:"
  GamesPlayedPerMonth.new.project(events).each do |month, count|
    puts "#{month}: #{count}"
  end
  puts

  puts "Players who play the most:"
  Top5PlayingPlayers.new.project(events).each do |player|
    puts "(#{player.player_id}) #{player.first_name} #{player.last_name} played #{player[:games_played]} games"
  end
  puts

  puts "Most played quizzes:"
  Top5PlayedQuizzes.new.project(events).each do |quiz|
    puts "(#{quiz[:quiz_id]}) #{quiz[:quiz_title]}: played #{quiz[:count]} times"
  end
  puts

  date = DateTime.parse('2014-09-14')
  player_activity = PlayerActivity.new(events, date)
  puts "#{player_activity.active.count} active players on #{date}"
  player_activity.active.each do |activity|
    puts "(#{activity.player.player_id}) #{activity.player.first_name} #{activity.player.last_name}: #{activity.games_played} games played"
  end
  puts
  puts "#{player_activity.inactive.count} inactive players on #{date}"
  player_activity.inactive.each do |activity|
    puts "(#{activity.player.player_id}) #{activity.player.first_name} #{activity.player.last_name}: #{activity.games_played} games played"
  end

end
