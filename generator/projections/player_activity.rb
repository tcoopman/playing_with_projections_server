require 'awesome_print'

class PlayerActivity
  def initialize(events, date)
    @events = events
    @player_activity = player_activity_on(date)
  end

  def active_on
    @player_activity.select{|e| e.games_played > 10}

  end

  def inactive_on
    @player_activity.select{|e| e.games_played < 1}

  end

  def player_activity_on(date)
    players.map do |player|
      games_played = join_events_on(date).select { |e| e.player_id == player.player_id }
      OpenStruct.new(player: player, games_played: games_played.count)
    end
  end

  def players
    @events.select { |e| e.type == 'PlayerHasRegistered' }
           .map(&:payload)
  end

  def join_events_on(date)
    @events.select { |e| e.type == 'PlayerJoinedGame' }
           .select { |e| in_range(date, e.timestamp) }
           .map(&:payload)
  end

  def in_range(reference_date, other_date)
    reference_date.year == other_date.year && reference_date.month == other_date.month
  end
end