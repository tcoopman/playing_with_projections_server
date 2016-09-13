class NumberOfPublishedQuizzes
  def project(stream )
    stream.select{|e| e['type'] == 'QuizWasPublished' }.count
  end
end

