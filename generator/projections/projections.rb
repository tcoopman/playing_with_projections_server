require_relative 'stream_reader.rb'
require_relative 'number_of_quizzes.rb'
require_relative 'quizzes_created_per_month.rb'

require 'json'
require 'rest-client'

def events(stream_name)
  base_uri = 'http://playing-with-projections.herokuapp.com'
  stream = "#{base_uri}/stream/#{stream_name}"
  puts "Reading from '#{stream}'"

  response = RestClient.get stream
  JSON.parse(response)
end

stream_name = ARGV.first
events = events(stream_name)

[
    NumberOfPublishedQuizzes,
    QuizzesPublishedPerMonth,
].each do |projector|
  puts projector.new.project(events)
end