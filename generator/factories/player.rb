class Player
  attr_accessor :id, :first_name, :last_name, :iq, :registration_date, :number_of_quizzes_to_create

  def create_quizzes
    (1..number_of_quizzes_to_create).map do
      quiz = yield
      quiz.author = self
      quiz
    end
  end
end

FactoryGirl.define do
  factory :player do
    id { SecureRandom.uuid }
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    iq
    registration_date
    number_of_quizzes_to_create
  end
end
