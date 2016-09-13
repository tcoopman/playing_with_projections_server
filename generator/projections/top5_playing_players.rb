class Top5PlayingPlayers
  def project(events)
    players = events.inject({}) do |hash, event|
      payload = event['payload']
      player_id = payload['player_id']
      if player_id
        if (hash[player_id] == nil)
          hash[player_id] = {games_played: 0}
        end

        data = hash[player_id]
        if event['type'] == 'PlayerHasRegistered'
          data[:player_id] = payload['player_id']
          data[:first_name] = payload['first_name']
          data[:last_name] = payload['last_name']
        end
        if event['type'] == 'PlayerJoinedGame'
          data[:games_played] += 1
        end
      end

      hash
    end

    players.values.sort_by { |player| -player[:games_played] }.take(5)
  end
end