class Top5PlayingPlayers
  def project(events)
    players = events.inject({}) do |hash, event|
      payload = event.payload
      player_id = payload.player_id
      if player_id
        if (hash[player_id] == nil)
          hash[player_id] = OpenStruct.new(games_played: 0)
        end

        data = hash[player_id]
        if event.type == 'PlayerHasRegistered'
          data.player_id = payload['player_id']
          data.first_name = payload['first_name']
          data.last_name = payload['last_name']
        end
        if event['type'] == 'PlayerJoinedGame'
          data.games_played += 1
        end
      end

      hash
    end

    players.values.sort_by { |player| -player.games_played }.take(5)
  end
end

class Top5PlayedQuizzes
  def project(events)
    quizzes = events.inject({}) do |hash, event|
      payload = event.payload
      quiz_id = payload.quiz_id
      if quiz_id
        if (hash[quiz_id] == nil)
          hash[quiz_id] = OpenStruct.new(count: 0)
        end

        data = hash[quiz_id]
        if event.type == 'QuizWasCreated'
          data.quiz_id = payload.quiz_id
          data.quiz_title = payload.quiz_title
        end
        if event.type == 'GameWasOpened'
          data.count += 1
        end
      end

      hash
    end

    quizzes.values.sort_by { |player| -player[:count] }.take(5)
  end
end