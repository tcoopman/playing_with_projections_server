require 'awesome_print'

class ActivePlayers
  def initialize(events)
    @events = events
  end

  def on(date)
    players = @events.select{ |e| e.type == 'PlayerHasRegistered' }
                     .map{|player| player.payload.dup}

    selection = @events.select do |e|
      e.type == 'PlayerJoinedGame'
    end
    .select do |event|
      event.timestamp.year == date.year && event.timestamp.month == date.month
    end
    selection
  end
end