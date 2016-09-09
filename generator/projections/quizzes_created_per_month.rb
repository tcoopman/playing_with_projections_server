require_relative 'stream_reader.rb'
stream = ARGV.first || 0

def month_of(quiz)
  date = DateTime.parse(quiz['timestamp'])
  "#{date.month}/#{date.year}"
end


require 'pry'
quizzes_per_month = StreamReader.events(stream).select{|e| e['type'] == 'QuizWasPublished' }.inject(Hash.new(0)) do |hash, quiz|
  hash[month_of(quiz)] += 1
  hash
end
puts 'Quizzes per month'
puts quizzes_per_month.inspect