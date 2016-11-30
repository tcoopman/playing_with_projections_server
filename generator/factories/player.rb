class Player
  attr_accessor :first_name, :last_name, :iq
end

FactoryGirl.define do
  iq_generator = Rubystats::NormalDistribution.new(100, 10)

  factory :player do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    iq { iq_generator.rng.round }
  end
end
