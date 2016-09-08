require 'faker'
require 'rubystats'
require 'time'
require_relative 'modules'
require_relative 'models'


module Statistics
  class Generator
    def generate_history
      startup_date = DateTime.parse('2016-1-1T08:00:00')
      top_date = startup_date + 150
      puts top_date
      date_generator = Rubystats::NormalDistribution.new(top_date, 50)
      iq_generator = Rubystats::NormalDistribution.new(100, 20)
      players = (1..20).map { Player.generate(date_generator, iq_generator) }
      quizzes = players.map(&:create_quizzes).flatten
      games = generate_games(players, quizzes)
      [players, quizzes, games].flatten
          .map(&:events).flatten
          .select{|e| e[:timestamp] < DateTime.now }
          .sort_by { |e| e[:timestamp] }
          .each{|e| e[:timestamp] = e[:timestamp].to_time.utc.iso8601}
    end

    def generate_games(players, quizzes)
      (1..100).map{ Game.generate(quizzes.sample, players.sample(5)) }
    end

  end
end
