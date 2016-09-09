require_relative 'stream_reader.rb'
stream = ARGV.first || 0

quiz_published = StreamReader.events(stream).select{|e| e['type'] == 'QuizWasPublished' }.count
puts "#{quiz_published} quizzes published"