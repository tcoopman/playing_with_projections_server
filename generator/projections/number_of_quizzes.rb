class NumberOfPublishedQuizzes
  def project(stream )
    count = stream.select{|e| e['type'] == 'QuizWasPublished' }.count
    "Number of quizzes published: #{count}"
  end
end

