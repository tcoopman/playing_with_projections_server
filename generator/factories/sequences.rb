FactoryGirl.define do
  registration_date_generator = Rubystats::NormalDistribution.new(DateTime.now, 100)
  sequence :registration_date do
    registration_date_generator.rng
  end
end
