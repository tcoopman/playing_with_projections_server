class Quiz
  attr_accessor :id
end

FactoryGirl.define do
  factory :quiz do
    id { SecureRandom.uuid }
  end
end
