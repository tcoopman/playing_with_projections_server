require 'json'
require 'factory_girl'
require 'faker'
require 'rubystats'

Dir["factories/*.rb"].each {|file| require_relative file }
Dir["events/*.rb"].each {|file| require_relative file }
Dir["projections/*.rb"].each {|file| require_relative file }
