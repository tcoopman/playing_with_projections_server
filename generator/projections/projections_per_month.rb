require_relative 'date_helper.rb'

class QuizzesPublishedPerMonth
  include DateHelper

  def project(stream )
    stream.select { |e| e['type'] == 'QuizWasPublished' }.inject(Hash.new(0)) do |hash, quiz|
      hash[month_of(quiz)] += 1
      hash
    end
  end
end

class GamesPlayedPerMonth
  include DateHelper

  def project(stream )
    stream.select { |e| e['type'] == 'GameWasOpened' }.inject(Hash.new(0)) do |hash, quiz|
      hash[month_of(quiz)] += 1
      hash
    end
  end
end
