require_relative 'dependencies'

stream_name = ARGV.first || '1'
file_name = "#{stream_name}.json"
puts "Generating #{file_name}"

number_of_players = Random.new.rand(800..1000)
players = (1..number_of_players).map{ FactoryGirl.build :player }
quizzes = (1..100).map{ FactoryGirl.build :quiz }

registration_date_generator = Rubystats::NormalDistribution.new(DateTime.now, 100)
events = players.map{|player| EventGenerator.generate('PlayerHasRegistered', registration_date_generator.rng, player: player) } +
         quizzes.map{|quiz| EventGenerator.generate('QuizWasCreated', DateTime.now, quiz: quiz) }

open(file_name, 'w') do |file|
  file.truncate(0)
  file.puts JSON.pretty_generate events
end

puts "#{NumberOfRegisteredPlayers.project(events)} players have registered"
puts "Players registered per month: #{NumberOfRegisteredPlayersPerMonth.project(events).inspect}"

puts "#{NumberOfQuizzesCreated.project(events)} quizzes created"
