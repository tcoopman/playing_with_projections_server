class NumberOfQuizzesCreated
  def self.project(events)
    events.select{|event| event[:type] == 'QuizWasCreated'}.count
  end
end
