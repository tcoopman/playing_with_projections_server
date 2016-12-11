class NumberOfPublishedQuizzes
  def project(stream )
    stream.select{|e| e['type'] == 'QuizWasPublished' }.count
  end
end

class NumberOfGamesPlayed
  def project(stream )
    stream.select{|e| e['type'] == 'GameWasOpened' }.count
  end
end

class NumberOfPlayers
  def project(stream )
    stream.select{|e| e['type'] == 'PlayerHasRegistered' }.count
  end
end