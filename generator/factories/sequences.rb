FactoryGirl.define do
  registration_date_generator = Rubystats::NormalDistribution.new(DateTime.now, 100)
  sequence :registration_date do
    registration_date_generator.rng
  end


  iq_generator = Rubystats::NormalDistribution.new(100, 10)
  sequence :iq do
    iq_generator.rng
  end

  number_of_quizzes_to_create_generator = Rubystats::NormalDistribution.new(20, 10)
  sequence :number_of_quizzes_to_create do
    number_of_quizzes_to_create_generator.rng
  end
end
