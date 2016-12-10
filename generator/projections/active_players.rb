class ActivePlayers
  def initialize(events)
    @events = events
  end

  def on(date)
    players = @events.select { |e| e['type'] == 'PlayerHasRegistered' }.map{|player| player['payload']}
  end
end