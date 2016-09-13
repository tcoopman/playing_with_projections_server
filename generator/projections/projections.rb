require_relative 'stream_reader.rb'
require_relative 'counter_projections.rb'
require_relative 'quizzes_created_per_month.rb'
require_relative 'top_5_projections.rb'

require 'json'
require 'pry'

def events(stream_name)
  base_uri = 'http://playing-with-projections.herokuapp.com'
  # base_uri = 'http://localhost:4000'
  stream = "#{base_uri}/stream/#{stream_name}"
  puts "Reading from '#{stream}'"

  response = RestClient.get stream
  JSON.parse(response)
end

stream_name = ARGV.first
events = events(stream_name)


puts
puts "#{NumberOfPublishedQuizzes.new.project(events)} quizzes published"
puts "#{NumberOfPlayers.new.project(events)} players"
puts "#{NumberOfGamesPlayed.new.project(events)} games played"
puts

puts "Quizzes published per month:"
QuizzesPublishedPerMonth.new.project(events).each do |month, count|
  puts "#{month}: #{count}"
end
puts

puts "Players who play the most:"
Top5PlayingPlayers.new.project(events).each do |player|
  puts "#{player[:first_name]} #{player[:last_name]} played #{player[:games_played]} games"
end
puts

puts "Most played quizzes:"
Top5PlayedQuizzes.new.project(events).each do |quiz|
  puts "#{quiz[:quiz_title]}: played #{quiz[:count]} times"
end
puts

