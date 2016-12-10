task :projections do
  Dir[File.dirname(__FILE__) + '/projections/*.rb'].each {|file| load file }
  run('../data/test.json')
end

