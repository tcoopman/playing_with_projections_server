require 'awesome_print'

class PlayerActivity
  def initialize(events, date)
    @events = events
    @date = date.to_date
    @week_before = @date - 7
    @player_activity = player_activity_on(date)
  end

  def active
    @player_activity.select{|e| e.games_played > 10}

  end

  def inactive
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
           .select { |e| in_range(e.timestamp) }
           .map(&:payload)
  end

  def in_range(date)
    @week_before < date && date <= @date
    # reference_date.year == other_date.year && reference_date.month == other_date.month
  end
end