require 'faker'
require 'rubystats'
require 'time'
require_relative 'modules'
require_relative 'models'


module Statistics
  class Generator
    def generate_history
      number_of_players = Random.new.rand(400..1000)

      startup_date = DateTime.parse('2016-5-1T08:00:00')
      top_date = startup_date + 150
      puts top_date
      date_generator = Rubystats::NormalDistribution.new(top_date, 50)
      iq_generator = Rubystats::NormalDistribution.new(100, 20)

      players = (1..number_of_players).map { Player.generate(date_generator, iq_generator) }
      quizzes = players.map{|player| player.create_quizzes(Random.new.rand(1..3))}.flatten
      games = generate_games(players, quizzes)
      [players, quizzes, games].flatten
          .map(&:events).flatten
          .sort_by { |e| e[:timestamp] }
          .each{|e| e[:timestamp] = e[:timestamp].to_time.utc.iso8601}
    end

    def generate_games(players, quizzes)
      number_of_games = Random.new.rand(5000..10000)
      weighted_games = weighted_by(quizzes, :popularity)
      weighted_players = weighted_by(players, :activity)

      (1..number_of_games).map{ Game.generate(weighted_games.sample, weighted_players.sample(5)) }
    end

    def weighted_by(array, attribute)
      result = []

      array.each do |item|
        (1..item.send(attribute)).each do
          result << item
        end
      end

      result
    end

  end
end
