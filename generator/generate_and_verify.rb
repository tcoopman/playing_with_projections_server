require_relative 'dependencies'

stream_name = ARGV.first || '1'
file_name = "#{stream_name}.json"
puts "Generating #{file_name}"

players = (1..100).map{ FactoryGirl.build :player }

registration_date_generator = Rubystats::NormalDistribution.new(DateTime.now, 100)
events = players.map{|player| EventGenerator.generate('PlayerHasRegistered', registration_date_generator.rng, player: player) }

open(file_name, 'w') do |file|
  file.truncate(0)
  file.puts JSON.pretty_generate events
end
