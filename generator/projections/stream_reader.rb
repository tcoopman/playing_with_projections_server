class StreamReader
  require 'json'
  require 'rest-client'

  def self.events(stream_id)
    base_uri = 'http://playing-with-projections.herokuapp.com'
    stream = "#{base_uri}/stream/#{stream_id}"
    puts "Reading from '#{stream}'"

    response = RestClient.get stream
    JSON.parse(response)
  end
end