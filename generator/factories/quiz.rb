class Quiz
  attr_accessor :id, :author
end

FactoryGirl.define do
  factory :quiz do
    id { SecureRandom.uuid }
  end
end
