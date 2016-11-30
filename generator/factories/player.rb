class Player
  attr_accessor :id, :first_name, :last_name, :iq
end

FactoryGirl.define do
  iq_generator = Rubystats::NormalDistribution.new(100, 10)

  factory :player do
    id { SecureRandom.uuid }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    iq { iq_generator.rng.round }
  end
end
