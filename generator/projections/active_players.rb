require 'awesome_print'

class ActivePlayers
  def initialize(events)
    @events = events
  end

  def on(date)
    join_events = @events.select { |e| in_range(date, e.timestamp) }
                         .select { |e| e.type == 'PlayerJoinedGame' }
                         .map(&:payload)
    players = @events.select { |e| e.type == 'PlayerHasRegistered' }
                     .map(&:payload)

    players.map do |player|
      games_played = join_events.select{|e| e.player_id == player.player_id}
      OpenStruct.new(player: player, games_played: games_played.count)
    end
           .select{|e| e.games_played > 10}

  end

  def in_range(reference_date, other_date)
    reference_date.year == other_date.year && reference_date.month == other_date.month
  end
end